<?php
/**
 * @package Admin
 */

if ( ! class_exists( 'Yoast_TextStatistics' ) ) {
    /**
     * Modified (Reduced) TextStatistics Class
     *
     * Mostly removed functionality that isn't needed within the WordPress SEO plugin.
     *
     * @link    http://code.google.com/p/php-text-statistics/
     * @link    https://github.com/DaveChild/Text-Statistics (new repo location)
     * @license http://www.opensource.org/licenses/bsd-license.php New BSD license
     *
     * @todo [JRF => whomever] Research if a class/library can be found which will offer
     * this functionality to a broader scope of languages/charsets.
     * Now basically limited to English.
     */
    class Yoast_TextStatistics {

        /**
         * @var string $strEncoding Used to hold character encoding to be used by object, if set
         */
        protected $strEncoding = '';

        /**
         * @var string $blnMbstring Efficiency: Is the MB String extension loaded ?
         */
        protected $blnMbstring = true;

        /**
         * @var bool $normalize Should the result be normalized ?
         */
        public $normalize = true;


        /**
         * Constructor.
         *
         * @param string  $strEncoding    Optional character encoding.
         */
        public function __construct( $strEncoding = '' ) {
            if ( $strEncoding <> '' ) {
                // Encoding is given. Use it!
                $this->strEncoding = $strEncoding;
            }
            $this->blnMbstring = extension_loaded( 'mbstring' );
        }

        /**
         * Gives the Flesch-Kincaid Reading Ease of text entered rounded to one digit
         *
         * @param  string $strText         Text to be checked
         * @return int|float
         */
        public function flesch_kincaid_reading_ease( $strText ) {
            $strText = $this->clean_text( $strText );
            $score   = $this->calc( $this->calc( 206.835, '-', $this->calc( 1.015, '*', $this->average_words_per_sentence( $strText ) ) ), '-', $this->calc( 84.6, '*', $this->average_syllables_per_word( $strText ) ) );

            return $this->normalize_score( $score, 0, 100 );
        }

        /**
         * Gives string length.
         *
         * @param  string $strText Text to be measured
         *
         * @return int
         */
        public function text_length( $strText ) {
            if ( ! $this->blnMbstring ) {
                return strlen( $strText );
            }

            try {
                if ( $this->strEncoding == '' ) {
                    $intTextLength = mb_strlen( $strText );
                } else {
                    $intTextLength = mb_strlen( $strText, $this->strEncoding );
                }
            } catch ( Exception $e ) {
                $intTextLength = strlen( $strText );
            }

            return $intTextLength;
        }

        /**
         * Gives letter count (ignores all non-letters). Tries mb_strlen and if that fails uses regular strlen.
         *
         * @param string $strText Text to be measured
         *
         * @return int
         */
        public function letter_count( $strText ) {
            $strText = $this->clean_text( $strText ); // To clear out newlines etc
            $strText = preg_replace( '`[^A-Za-z]+`', '', $strText );

            if ( ! $this->blnMbstring ) {
                return strlen( $strText );
            }

            try {
                if ( $this->strEncoding == '' ) {
                    $intTextLength = mb_strlen( $strText );
                } else {
                    $intTextLength = mb_strlen( $strText, $this->strEncoding );
                }
            } catch ( Exception $e ) {
                $intTextLength = strlen( $strText );
            }

            return $intTextLength;
        }

        /**
         * Trims, removes line breaks, multiple spaces and generally cleans text before processing.
         *
         * @param string $strText      Text to be transformed
         * @return string
         */
        protected function clean_text( $strText ) {
            static $clean = array();

            $key = sha1( $strText );

            if ( isset( $clean[ $key ] ) ) {
                return $clean[ $key ];
            }

            // all these tags should be preceeded by a full stop.
            $fullStopTags = array( 'li', 'p', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6', 'dd' );
            foreach ( $fullStopTags as $tag ) {
                $strText = str_ireplace( '</' . $tag . '>', '.', $strText );
            }
            $strText = strip_tags( $strText );
            $strText = preg_replace( '`[",:;\(\)-]`', ' ', $strText ); // Replace commas, hyphens etc (count them as spaces)
            $strText = preg_replace( '`[\.!?]`', '.', $strText ); // Unify terminators
            $strText = trim( $strText ) . '.'; // Add final terminator, just in case it's missing.
            $strText = preg_replace( '`[ ]*(\n|\r\n|\r)[ ]*`', ' ', $strText ); // Replace new lines with spaces
            $strText = preg_replace( '`([\.])[\. ]+`', '$1', $strText ); // Check for duplicated terminators
            $strText = trim( preg_replace( '`[ ]*([\.])`', '$1 ', $strText ) ); // Pad sentence terminators
            $strText = preg_replace( '` [0-9]+ `', ' ', ' ' . $strText . ' ' ); // Remove "words" comprised only of numbers
            $strText = preg_replace( '`[ ]+`', ' ', $strText ); // Remove multiple spaces
            $strText = preg_replace_callback( '`\. [^ ]+?`', create_function( '$matches', 'return strtolower( $matches[0] );' ), $strText ); // Lower case all words following terminators (for gunning fog score)

            $strText = trim( $strText );

            // Cache it and return
            $clean[ $key ] = $strText;
            return $strText;
        }

        /**
         * Converts string to lower case. Tries mb_strtolower and if that fails uses regular strtolower.
         *
         * @param string $strText      Text to be transformed
         * @return string
         */
        protected function lower_case( $strText ) {

            if ( ! $this->blnMbstring ) {
                return strtolower( $strText );
            }

            try {
                if ( $this->strEncoding == '' ) {
                    $strLowerCaseText = mb_strtolower( $strText );
                } else {
                    $strLowerCaseText = mb_strtolower( $strText, $this->strEncoding );
                }
            } catch ( Exception $e ) {
                $strLowerCaseText = strtolower( $strText );
            }

            return $strLowerCaseText;
        }

        /**
         * Converts string to upper case. Tries mb_strtoupper and if that fails uses regular strtoupper.
         *
         * @param string $strText      Text to be transformed
         * @return string
         */
        protected function upper_case( $strText ) {
            if ( ! $this->blnMbstring ) {
                return strtoupper( $strText );
            }

            try {
                if ( $this->strEncoding == '' ) {
                    $strUpperCaseText = mb_strtoupper( $strText );
                } else {
                    $strUpperCaseText = mb_strtoupper( $strText, $this->strEncoding );
                }
            } catch ( Exception $e ) {
                $strUpperCaseText = strtoupper( $strText );
            }

            return $strUpperCaseText;
        }

        /**
         * Returns sentence count for text.
         *
         * @param   string $strText      Text to be measured
         * @return int
         */
        public function sentence_count( $strText ) {
            if ( strlen( trim( $strText ) ) == 0 ) {
                return 0;
            }

            $strText = $this->clean_text( $strText );
            // Will be tripped up by "Mr." or "U.K.". Not a major concern at this point.
            // [JRF] Will also be tripped up by ... or ?!
            // @todo [JRF => whomever] May be replace with something along the lines of this - will at least provide better count in ... and ?! situations:
            // $intSentences = max( 1, preg_match_all( '`[^\.!?]+[\.!?]+([\s]+|$)`u', $strText, $matches ) ); [/JRF]
            $intSentences = max( 1, $this->text_length( preg_replace( '`[^\.!?]`', '', $strText ) ) );
            return $intSentences;
        }

        /**
         * Returns word count for text.
         *
         * @param  string $strText      Text to be measured
         * @return int
         */
        public function word_count( $strText ) {
            if ( strlen( trim( $strText ) ) == 0 ) {
                return 0;
            }

            $strText = $this->clean_text( $strText );
            // Will be tripped by em dashes with spaces either side, among other similar characters
            $intWords = 1 + $this->text_length( preg_replace( '`[^ ]`', '', $strText ) ); // Space count + 1 is word count
            return $intWords;
        }

        /**
         * Returns average words per sentence for text.
         *
         * @param string $strText      Text to be measured
         * @return int|float
         */
        public function average_words_per_sentence( $strText ) {
            $strText          = $this->clean_text( $strText );
            $intSentenceCount = $this->sentence_count( $strText );
            $intWordCount     = $this->word_count( $strText );
            return ( $this->calc( $intWordCount, '/', $intSentenceCount ) );
        }

        /**
         * Returns average syllables per word for text.
         *
         * @param string  $strText      Text to be measured
         * @return int|float
         */
        public function average_syllables_per_word( $strText ) {
            $strText          = $this->clean_text( $strText );
            $intSyllableCount = 0;
            $intWordCount     = $this->word_count( $strText );
            $arrWords         = explode( ' ', $strText );
            for ( $i = 0; $i < $intWordCount; $i++ ) {
                $intSyllableCount += $this->syllable_count( $arrWords[ $i ] );
            }
            return ( $this->calc( $intSyllableCount, '/', $intWordCount ) );
        }

        /**
         * Returns the number of syllables in the word.
         * Based in part on Greg Fast's Perl module Lingua::EN::Syllables
         *
         * @param string  $strWord Word to be measured
         * @return int
         */
        public function syllable_count( $strWord ) {
            if ( strlen( trim( $strWord ) ) == 0 ) {
                return 0;
            }

            // Should be no non-alpha characters
            $strWord = preg_replace( '`[^A-Za-z]`', '', $strWord );

            $intSyllableCount = 0;
            $strWord          = $this->lower_case( $strWord );

            // Specific common exceptions that don't follow the rule set below are handled individually
            // Array of problem words (with word as key, syllable count as value)
            $arrProblemWords = array(
                'simile'    => 3,
                'forever'   => 3,
                'shoreline' => 2,
            );
            if ( isset( $arrProblemWords[ $strWord ] ) ) {
                $intSyllableCount = $arrProblemWords[ $strWord ];
            }
            if ( $intSyllableCount > 0 ) {
                return $intSyllableCount;
            }

            // These syllables would be counted as two but should be one
            $arrSubSyllables = array(
                'cial',
                'tia',
                'cius',
                'cious',
                'giu',
                'ion',
                'iou',
                'sia$',
                '[^aeiuoyt]{2,}ed$',
                '.ely$',
                '[cg]h?e[rsd]?$',
                'rved?$',
                '[aeiouy][dt]es?$',
                '[aeiouy][^aeiouydt]e[rsd]?$',
                // Sorts out deal, deign etc
                '^[dr]e[aeiou][^aeiou]+$',
                // Purse, hearse
                '[aeiouy]rse$',
            );

            // These syllables would be counted as one but should be two
            $arrAddSyllables = array(
                'ia',
                'riet',
                'dien',
                'iu',
                'io',
                'ii',
                '[aeiouym]bl$',
                '[aeiou]{3}',
                '^mc',
                'ism$',
                '([^aeiouy])\1l$',
                '[^l]lien',
                '^coa[dglx].',
                '[^gq]ua[^auieo]',
                'dnt$',
                'uity$',
                'ie(r|st)$',
            );

            // Single syllable prefixes and suffixes
            $arrPrefixSuffix = array(
                '`^un`',
                '`^fore`',
                '`ly$`',
                '`less$`',
                '`ful$`',
                '`ers?$`',
                '`ings?$`',
            );

            // Remove prefixes and suffixes and count how many were taken
            $strWord = preg_replace( $arrPrefixSuffix, '', $strWord, -1, $intPrefixSuffixCount );

            // Removed non-word characters from word
            $strWord          = preg_replace( '`[^a-z]`is', '', $strWord );
            $arrWordParts     = preg_split( '`[^aeiouy]+`', $strWord );
            $intWordPartCount = 0;
            foreach ( $arrWordParts as $strWordPart ) {
                if ( $strWordPart <> '' ) {
                    $intWordPartCount++;
                }
            }

            // Some syllables do not follow normal rules - check for them
            // Thanks to Joe Kovar for correcting a bug in the following lines
            $intSyllableCount = $intWordPartCount + $intPrefixSuffixCount;
            foreach ( $arrSubSyllables as $strSyllable ) {
                $intSyllableCount -= preg_match( '`' . $strSyllable . '`', $strWord );
            }
            foreach ( $arrAddSyllables as $strSyllable ) {
                $intSyllableCount += preg_match( '`' . $strSyllable . '`', $strWord );
            }
            $intSyllableCount = ( $intSyllableCount == 0 ) ? 1 : $intSyllableCount;
            return $intSyllableCount;
        }

        /**
         * Normalizes score according to min & max allowed. If score larger
         * than max, max is returned. If score less than min, min is returned.
         * Also rounds result to specified precision.
         * Thanks to github.com/lvil.
         *
         * @param    int|float  $score    Initial score
         * @param    int        $min     Minimum score allowed
         * @param    int        $max     Maximum score allowed
         * @return    int|float
         */
        public function normalize_score( $score, $min, $max, $dps = 1 ) {
            $score = $this->calc( $score, '+', 0, true, $dps ); // Round
            if ( ! $this->normalize ) {
                return $score;
            }

            if ( $score > $max ) {
                $score = $max;
            } elseif ( $score < $min ) {
                $score = $min;
            }

            return $score;
        }
        
        /**
         * Do simple reliable math calculations without the risk of wrong results
         * @see http://floating-point-gui.de/
         * @see the big red warning on http://php.net/language.types.float.php
         *
         * In the rare case that the bcmath extension would not be loaded, it will return the normal calculation results
         *
         * @static
         *
         * @since 1.5.0
         *
         * @param   mixed   $number1    Scalar (string/int/float/bool)
         * @param   string  $action     Calculation action to execute. Valid input:
         *                              '+' or 'add' or 'addition',
         *                              '-' or 'sub' or 'subtract',
         *                              '*' or 'mul' or 'multiply',
         *                              '/' or 'div' or 'divide',
         *                              '%' or 'mod' or 'modulus'
         *                              '=' or 'comp' or 'compare'
         * @param   mixed   $number2    Scalar (string/int/float/bool)
         * @param   bool    $round      Whether or not to round the result. Defaults to false.
         *                              Will be disregarded for a compare operation
         * @param   int     $decimals   Decimals for rounding operation. Defaults to 0.
         * @param   int     $precision  Calculation precision. Defaults to 10.
         *
         * @return  mixed               Calculation Result or false if either or the numbers isn't scalar or
         *                              an invalid operation was passed
         *                              - for compare the result will always be an integer
         *                              - for all other operations, the result will either be an integer (preferred)
         *                              or a float
         */
         public function calc($number1, $action, $number2, $round = false, $decimals = 0, $precision = 10) {
        	static $bc;
        
        	if (! is_scalar($number1) || ! is_scalar($number2)) {
        		return false;
        	}
        
        	if (! isset($bc)) {
        		$bc = extension_loaded('bcmath');
        	}
        
        	if ($bc) {
        		$number1 = number_format($number1, 10, '.', '');
        		$number2 = number_format($number2, 10, '.', '');
        	}
        
        	$result  = null;
        	$compare = false;
        
        	switch ($action) {
        	    case '+':
        	    case 'add':
        	    case 'addition':
        	    	$result = ($bc) ? bcadd($number1, $number2, $precision) /* string */ : ($number1 + $number2);
        	    	break;
        
        	    case '-':
        	    case 'sub':
        	    case 'subtract':
        	    	$result = ($bc) ? bcsub($number1, $number2, $precision) /* string */ : ($number1 - $number2);
        	    	break;
        
        	    case '*':
        	    case 'mul':
        	    case 'multiply':
        	    	$result = ($bc) ? bcmul($number1, $number2, $precision) /* string */ : ($number1 * $number2);
        	    	break;
        
        	    case '/':
        	    case 'div':
        	    case 'divide':
        	    	if ($bc) {
        	    		$result = bcdiv($number1, $number2, $precision); // string, or NULL if right_operand is 0
        	    	}
        	    	elseif ($number2 != 0) {
        	    		$result = $number1 / $number2;
        	    	}
        
        	    	if (! isset($result)) {
        	    		$result = 0;
        	    	}
        	    	break;
        
        	    case '%':
        	    case 'mod':
        	    case 'modulus':
        	    	if ($bc) {
        	    		$result = bcmod($number1, $number2, $precision); // string, or NULL if modulus is 0.
        	    	}
        	    	elseif ($number2 != 0) {
        	    		$result = $number1 % $number2;
        	    	}
        
        	    	if (! isset($result)) {
        	    		$result = 0;
        	    	}
        	    	break;
        
        	    case '=':
        	    case 'comp':
        	    case 'compare':
        	    	$compare = true;
        	    	if ($bc) {
        	    		$result = bccomp($number1, $number2, $precision); // returns int 0, 1 or -1
        	    	}
        	    	else {
        	    		$result = ($number1 == $number2) ? 0 : (($number1 > $number2) ? 1 : -1);
        	    	}
        	    	break;
        	}
        
        	if (isset($result)) {
        		if ($compare === false) {
        			if ($round === true) {
        				$result = round(floatval($result), $decimals);
        				if ($decimals === 0) {
        					$result = (int) $result;
        				}
        			}
        			else {
        				$result = (intval($result) == $result) ? intval($result) : floatval($result);
        			}
        		}
        		return $result;
        	}
        	return false;
        }

    } /* End of class */
    
} /* End of class-exists wrapper */
