<?php
class MUSeo_Api_Scoring extends Zikula_AbstractApi
{
    private $totalScore = array();
    private $pageUrl;
    private $keyword;
    private $keywordFolded;
    private $statistics;
    
    
     public function __construct(Zikula_ServiceManager $serviceManager) {
        parent::__construct($serviceManager);
        require('modules/MUSeo/lib/vendor/Yoast/TextStatistics.php');
        $this->statistics = new Yoast_TextStatistics('utf-8');
     }
     
     public function score($url, $keyword){
         $this->pageUrl = $url;
         $this->keyword = $keyword;
         $this->keywordFolded = $this->strip_separators_and_fold($this->keyword);
         

         $dom = new DOMDocument();
        $dom->strictErrorChecking = false;
        $dom->preserveWhiteSpace  = false;
        
        $dom->loadHTMLFile($url);
        

        $xpath = new DOMXPath($dom);

        
        //TODO: How to handle this?
        // Check if this focus keyword has been used already.
        //$this->check_double_focus_keyword($job, $results);
        
        // Keyword
        $this->score_keyword($this->keyword);

        // URL
        $this->score_url($this->pageUrl);
        
        //title
        $this->score_title($xpath->query("/html/head/title")->item(0)->textContent);
        
        //meta description
        $this->score_description($xpath->query('/html/head/meta[@name="description"]/@content')->item(0)->textContent);

        //body
        $body = $xpath->query('/html/body')->item(0)->textContent;
        $body = preg_replace('`<(?:\x20*script|script).*?(?:/>|/script>)`', '', $body);
        $body = preg_replace('`<!--.*?-->`', '', $body);
        $body = preg_replace('`<(?:\x20*style|style).*?(?:/>|/style>)`', '', $body);

        $firstp = '';
        if (preg_match('`<p[.]*?>(.*)</p>`s', $body, $matches)) {
            $firstp = $matches[1];
        }        
        
        $this->score_body($body, $firstp);

        // Headings
        $headings = array();
        
        preg_match_all('`<h([1-6])(?:[^>]+)?>(.*?)</h\\1>`si', $body, $matches);
        
        if (isset($matches[2]) && is_array($matches[2]) && $matches[2] !== array()) {
            foreach ($matches[2] as $heading) {
                $headings[] = strtolower($heading);
            }
        }
        
        $this->score_headings($headings);

        // Images
        $imgs = array();
        $imgs['count'] = $xpath->query('//img')->length;
            
        foreach($xpath->query('//img/@alt') as $img){
            if(!empty($img->nodeValue)){
                $imgs['alts'][] = $img->nodeValue;
            }
                
        }
        
        $this->score_images_alt_text($imgs);

        // Anchors
        $anchors = $this->get_anchor_texts($xpath);
        $count   = $this->get_anchor_count($xpath);
        
        $this->score_anchor_texts($anchors, $count);
    
        
        $this->aasort($this->totalScore , 'val');
        
        $overall     = 0;
        $overall_max = 0;
        
        foreach ($this->totalScore as $result) {
            $overall += $result['val'];
            $overall_max += 9;
        }
        
        if ($overall < 1) {
            $overall = 1;
        }

        $this->totalScore['total'] = $this->calc($this->calc($overall, '/', $overall_max), '*', 100, true);
        
        
        return $this->totalScore;
     }

    
    /**
     * Save the score result to the results array.
     *
     * @param array  $results      The results array used to store results.
     * @param int    $scoreValue   The score value.
     * @param string $scoreMessage The score message.
     * @param string $scoreLabel   The label of the score to use in the results array.
     * @param string $rawScore     The raw score, to be used by other filters.
     */
    function save_score_result($scoreValue, $scoreMessage, $scoreLabel, $rawScore = null) {
        $score = array(
                'val' => $scoreValue,
                'msg' => $scoreMessage,
                'raw' => $rawScore,
        );
        $this->totalScore[$scoreLabel] = $score;
    }
    
    
    /**
     * Check whether the keyword contains stopwords.
     *
     * @param string $keyword The keyword to check for stopwords.
     */
    private function score_keyword($keyword) {
        $containingStopword = self::stopwords_check($keyword);
    
        if ($containingStopword !== false) {
            $this->save_score_result(5, $this->__f('The keyword for this page contains one or more %sstop words%s, consider removing them. Found \'%s\'.', array('<a href="http://en.wikipedia.org/wiki/Stop_words">', '</a>', $containingStopword)), 'keyword_stopwords');
        }
    }
    
    /**
     * Check whether the stopword appears in the string
     *
     * @param string $haystack    The string to be checked for the stopword
     *
     * @return bool|mixed
     */
    private function stopwords_check($haystack) {
        $stopWords = explode(',', $this->__("a,about,above,after,again,against,all,am,an,and,any,are,as,at,be,because,been,before,being,below,between,both,but,by,could,did,do,does,doing,down,during,each,few,for,from,further,had,has,have,having,he,he'd,he'll,he's,her,here,here's,hers,herself,him,himself,his,how,how's,i,i'd,i'll,i'm,i've,if,in,into,is,it,it's,its,itself,let's,me,more,most,my,myself,nor,of,on,once,only,or,other,ought,our,ours,ourselves,out,over,own,same,she,she'd,she'll,she's,should,so,some,such,than,that,that's,the,their,theirs,them,themselves,then,there,there's,these,they,they'd,they'll,they're,they've,this,those,through,to,too,under,until,up,very,was,we,we'd,we'll,we're,we've,were,what,what's,when,when's,where,where's,which,while,who,who's,whom,why,why's,with,would,you,you'd,you'll,you're,you've,your,yours,yourself,yourselves"));
    
        if (is_array($stopWords) && empty($stopWords)) {
            foreach ($stopWords as $stopWord) {
                // Check whether the stopword appears as a whole word
                // @todo [JRF => whomever] check whether the use of \b (=word boundary) would be more efficient ;-)
                $res = preg_match("`(^|[ \n\r\t\.,'\(\)\"\+;!?:])" . preg_quote($stopWord, '`') . "($|[ \n\r\t\.,'\(\)\"\+;!?:])`iu", $haystack, $match);
                if ($res > 0) {
                    return $stopWord;
                }
            }
        }
    
        return false;
    }
    
    /**
     * Check whether the keyword is contained in the title.
     *
     * @param array $job     The job array holding both the keyword versions.
     * @param array $results The results array.
     */
    private function score_title($title) {
        $scoreTitleMinLength    = 40;
        $scoreTitleMaxLength    = 70;
        $scoreTitleKeywordLimit = 0;
    
    
        if ($title == '') {
            $this->save_score_result( 1, $this->__('Please create a page title.'), 'title');
        } else {
    
            $length = $this->statistics->text_length($title);
            if ($length < $scoreTitleMinLength) {
                $this->save_score_result(6, $this->__f('The page title contains %d characters, which is less than the recommended minimum of 40 characters. Use the space to add keyword variations or create compelling call-to-action copy.', array($length)), 'title_length');
            } elseif ($length > $scoreTitleMaxLength) {
                $this->save_score_result(6, $this->__f('The page title contains %d characters, which is more than the viewable limit of 70 characters; some words will not be visible to users in your listing.', array($length)), 'title_length');
            } else {
                $this->save_score_result(9, $this->__('The page title is more than 40 characters and less than the recommended 70 character limit.'), 'title_length');
            }
    
            // @todo MA Keyword/Title matching is exact match with separators removed, but should extend to distributed match
            $needle_position = stripos($title, $this->keywordFolded);
    
            if ($needle_position === false) {
                $needle_position = stripos($title, $this->keyword);
            }
    
            if ($needle_position === false) {
                $this->save_score_result(2, $this->__f('The keyword / phrase %s does not appear in the page title.', array($this->keywordFolded)), 'title_keyword');
            } elseif ($needle_position <= $scoreTitleKeywordLimit) {
                $this->save_score_result(9, $this->__('The page title contains keyword / phrase, at the beginning which is considered to improve rankings.'), 'title_keyword');
            } else {
                $this->save_score_result(6, $this->__('The page title contains keyword / phrase, but it does not appear at the beginning; try and move it to the beginning.'), 'title_keyword');
            }
        }
    }
    
    /**
     * Score the meta description for length and keyword appearance.
     *
     * @param array  $job         The array holding the keywords.
     * @param array  $results     The results array.
     * @param string $description The meta description.
     * @param int    $maxlength   The maximum length of the meta description.
     */
    private function score_description($description, $maxlength = 155) {
        $scoreDescriptionMinLength = 120;
    
        $metaShorter = '';
        if ($maxlength != 155) {
            $metaShorter = $this->__('The available space is shorter than the usual 155 characters because Google will also include the publication date in the snippet.');
        }
    
        if ($description == '') {
            $this->save_score_result(1, $this->__('No meta description has been specified, search engines will display copy from the page instead.'), 'description_length');
        } else {
            $length = $this->statistics->text_length($description);
    
            if ($length < $scoreDescriptionMinLength) {
                $this->save_score_result(6, $this->__f('The meta description is under 120 characters, however up to %s characters are available. %s', array($maxlength, $metaShorter)), 'description_length');
            } elseif ($length <= $maxlength) {
                $this->save_score_result(9, $this->__('In the specified meta description, consider: How does it compare to the competition? Could it be made more appealing?'), 'description_length');
            } else {
                $this->save_score_result(6, $this->__f('The specified meta description is over %s characters, reducing it will ensure the entire description is visible. %s', array($maxlength, $metaShorter)), 'description_length');
            }
            
            // @todo MA Keyword/Title matching is exact match with separators removed, but should extend to distributed match
            $haystack1 = $this->strip_separators_and_fold($description, true);
            $haystack2 = $this->strip_separators_and_fold($description, false);
            if (strrpos($haystack1, $this->keywordFolded) === false && strrpos($haystack2, $this->keywordFolded) === false) {
                $this->save_score_result(3, $this->__('A meta description has been specified, but it does not contain the target keyword / phrase.'), 'description_keyword');
            } else {
                $this->save_score_result(9, $this->__('The meta description contains the primary keyword / phrase.'), 'description_keyword');
            }
        }
    }
    
    /**
     * Score the body for length and keyword appearance.
     *
     * @param array  $job     The array holding the keywords.
     * @param array  $results The results array.
     * @param string $body    The body.
     * @param string $firstp  The first paragraph.
     */
    private function score_body($body, $firstp) {
        $lengthScore = array(
                'good' => 300,
                'ok'   => 250,
                'poor' => 200,
                'bad'  => 100,
        );

        // Replace images with their alt tags, then strip all tags
        $body = preg_replace('`<img(?:[^>]+)?alt="([^"]+)"(?:[^>]+)>`', '$1', $body);
        $body = strip_tags($body);
    
        // Copy length check
        $wordCount = $this->statistics->word_count($body);
    
        if ($wordCount < $lengthScore['bad']) {
            $this->save_score_result(- 20, $this->__f('There are %d words contained in the body copy. This is far too low and should be increased.', array($wordCount, $lengthScore['good'])), 'body_length', array($wordCount));
        } elseif ($wordCount < $lengthScore['poor']) {
            $this->save_score_result(- 10, $this->__f('There are %d words contained in the body copy, this is below the %d word recommended minimum. Add more useful content on this topic for readers.', array($wordCount, $lengthScore['good'])), 'body_length', $wordCount);
        } elseif ($wordCount < $lengthScore['ok']) {
            $this->save_score_result(5, $this->__f('There are %d words contained in the body copy, this is below the %d word recommended minimum. Add more useful content on this topic for readers.', array($wordCount, $lengthScore['good'])), 'body_length', $wordCount);
        } elseif ($wordCount < $lengthScore['good']) {
            $this->save_score_result(7, $this->__f('There are %d words contained in the body copy, this is slightly below the %d word recommended minimum, add a bit more copy.', array($wordCount, $lengthScore['good'])), 'body_length', $wordCount);
        } else {
            $this->save_score_result(9, $this->__f('There are %d words contained in the body copy, this is more than the %d word recommended minimum.', array($wordCount, $lengthScore['good'])), 'body_length', $wordCount);
        }
    
        $body           = strtolower($body);
        $this->keyword = strtolower($this->keyword);
    
        $keywordWordCount = $this->statistics->word_count($this->keyword);
    
        if ($keywordWordCount > 10) {
            $this->save_score_result(0, $this->__('Your keyphrase is over 10 words, a keyphrase should be shorter and there can be only one keyphrase.'), 'focus_keyword_length');
        } else {
            // Keyword Density check
            $keywordDensity = 0;
            if ($wordCount > 100) {
                $keywordCount = preg_match_all('`\b' . preg_quote($this->keyword, '`') . '\b`miu', $body, $res);
                if (($keywordCount > 0 && $keywordWordCount > 0) && $wordCount > $keywordCount) {
                    $keywordDensity = $this->calc($this->calc($keywordCount, '/', $this->calc($wordCount, '-', ($this->calc($this->calc($keywordWordCount, '-', 1), '*', $keywordCount)))), '*', 100, true, 2);
                }
                if ($keywordDensity < 1) {
                    $this->save_score_result(4, $this->__f('The keyword density is %s%%, which is a bit low, the keyword was found %s times.', array($keywordDensity, $keywordCount)), 'keyword_density');
                } elseif ($keywordDensity > 4.5) {
                    $this->save_score_result(- 50, $this->__f('The keyword density is %s%%, which is over the advised 4.5%% maximum, the keyword was found %s times.', array($keywordDensity, $keywordCount)), 'keyword_density');
                } else {
                    $this->save_score_result(9, $this->__f('The keyword density is %s%%, which is great, the keyword was found %s times.', array($keywordDensity, $keywordCount)), 'keyword_density');
                }
            }
        }
    
        $firstp = strtolower($firstp);
    
        // First Paragraph Test
        // check without /u modifier as well as /u might break with non UTF-8 chars.
        if (preg_match('`\b' . preg_quote($this->keyword, '`') . '\b`miu', $firstp) || preg_match('`\b' . preg_quote($this->keyword, '`') . '\b`mi', $firstp) || preg_match('`\b' . preg_quote($this->keywordFolded, '`') . '\b`miu', $firstp)
        ) {
            $this->save_score_result(9, $this->__('The keyword appears in the first paragraph of the copy.'), 'keyword_first_paragraph');
        } else {
            $this->save_score_result(3, $this->__('The keyword doesn\'t appear in the first paragraph of the copy, make sure the topic is clear immediately.'), 'keyword_first_paragraph');
        }
    
        if (substr(ZLanguage::getLanguageCode(), 0, 2) == 'en' && $wordCount > 100) {
            // Flesch Reading Ease check
            $flesch = $this->statistics->flesch_kincaid_reading_ease($body);
    
            $note  = '';
            $level = '';
            $score = 1;
            if ($flesch >= 90) {
                $level = $this->__('very easy');
                $score = 9;
            } elseif ($flesch >= 80) {
                $level = $this->__('easy');
                $score = 9;
            } elseif ($flesch >= 70) {
                $level = $this->__('fairly easy');
                $score = 8;
            } elseif ($flesch >= 60) {
                $level = $this->__('OK');
                $score = 7;
            } elseif ($flesch >= 50) {
                $level = $this->__('fairly difficult');
                $note  = $this->__('Try to make shorter sentences to improve readability.');
                $score = 6;
            } elseif ($flesch >= 30) {
                $level = $this->__('difficult');
                $note  = $this->__('Try to make shorter sentences, using less difficult words to improve readability.');
                $score = 5;
            } elseif ($flesch >= 0) {
                $level = $this->__('very difficult');
                $note  = $this->__('Try to make shorter sentences, using less difficult words to improve readability.');
                $score = 4;
            }
            
            $fleschurl   = '<a href="http://en.wikipedia.org/wiki/Flesch-Kincaid_readability_test#Flesch_Reading_Ease">' . $this->__('Flesch Reading Ease') . '</a>';
            $scoreFlesch = $this->__('The copy scores %s in the %s test, which is considered %s to read. %s');
            
            $this->save_score_result($score, $this->__f('The copy scores %s in the %s test, which is considered %s to read. %s', array($flesch, '<a href="http://en.wikipedia.org/wiki/Flesch-Kincaid_readability_test#Flesch_Reading_Ease">' . $this->__('Flesch Reading Ease') . '</a>', $level, $note)), 'flesch_kincaid');
        }
    }
    
    /**
     * Check whether the keyword is contained in the URL.
     *
     * @param array $job     The job array holding both the keyword and the URLs.
     * @param array $results The results array.
     */
    private function score_url() {    
        //TODO: remove_accents in Zikula
        //$needle    = $this->strip_separators_and_fold(remove_accents($this->keyword));
        
        $needle    = $this->strip_separators_and_fold($this->keyword);
        $haystack1 = $this->strip_separators_and_fold($this->pageUrl, true);
        $haystack2 = $this->strip_separators_and_fold($this->pageUrl, false);
    
        if (stripos($haystack1, $needle) || stripos($haystack2, $needle)) {
            $this->save_score_result(9, $this->__('The keyword / phrase appears in the URL for this page.'), 'url_keyword');
        } else {
            $this->save_score_result(6, $this->__('The keyword / phrase does not appear in the URL for this page. If you decide to rename the URL be sure to check the old URL 301 redirects to the new one!'), 'url_keyword');
        }
    
        /*
        // Check for Stop Words in the slug
        if ($wpseo_admin->stopwords_check($job['pageSlug'], true) !== false) {
            $this->save_score_result(5, $this->__('The slug for this page contains one or more <a href="http://en.wikipedia.org/wiki/Stop_words">stop words</a>, consider removing them.'), 'url_stopword');
        }
    
        // Check if the slug isn't too long relative to the length of the keyword
        if (($this->statistics->text_length($this->keyword) + 20) < $this->statistics->text_length($job['pageSlug']) && 40 < $this->statistics->text_length($job['pageSlug'])) {
            $this->save_score_result(5, $this->__('The slug for this page is a bit long, consider shortening it.'), 'url_length');
        }*/
    }
    
    /**
     * Check whether the document contains outbound links and whether it's anchor text matches the keyword.
     *
     * @param array $job          The job array holding both the keyword versions.
     * @param array $results      The results array.
     * @param array $anchor_texts The array holding all anchors in the document.
     * @param array $count        The number of anchors in the document, grouped by type.
     */
    private function score_anchor_texts($anchor_texts, $count) {
        if ($count['external']['nofollow'] == 0 && $count['external']['dofollow'] == 0) {
            $this->save_score_result(6, $this->__('No outbound links appear in this page, consider adding some as appropriate.'), 'links');
        } else {
            $found = false;
            if (is_array($anchor_texts) && $anchor_texts !== array()) {
                foreach ($anchor_texts as $anchor_text) {
                    if (strtolower($anchor_text) == $this->keywordFolded) {
                        $found = true;
                    }
                }
            }
            if ($found) {
                $this->save_score_result(2, $this->__('You\'re linking to another page with the keyword you want this page to rank for, consider changing that if you truly want this page to rank.'), 'links_focus_keyword');
            }
    
            if ($count['external']['nofollow'] == 0 && $count['external']['dofollow'] > 0) {
                $this->save_score_result(9, $this->__f('This page has %s outbound link(s).', array($count['external']['dofollow'])), 'links_number');
            } elseif ($count['external']['nofollow'] > 0 && $count['external']['dofollow'] == 0) {
                $this->save_score_result(7, $this->__f('This page has %s outbound link(s), all nofollowed.', array($count['external']['nofollow'])), 'links_number');
            } else {
                $this->save_score_result(8, $this->__f('This page has %s nofollowed link(s) and %s normal outbound link(s).', array($count['external']['nofollow'], $count['external']['dofollow'])), 'links_number');
            }
        }
    }
    
    /**
     * Retrieve the anchor texts used in the current document.
     *
     * @param object $xpath An XPATH object of the current document.
     *
     * @return array
     */
    function get_anchor_texts(&$xpath) {
        $query        = '//a|//A';
        $dom_objects  = $xpath->query($query);
        $anchor_texts = array();
        if (is_object($dom_objects) && is_a($dom_objects, 'DOMNodeList') && $dom_objects->length > 0) {
            foreach ($dom_objects as $dom_object) {
                if ($dom_object->attributes->getNamedItem('href')) {
                    $href = $dom_object->attributes->getNamedItem('href')->textContent;
                    if (substr($href, 0, 4) == 'http') {
                        $anchor_texts['external'] = $dom_object->textContent;
                    }
                }
            }
        }
    
        return $anchor_texts;
    }
    
    /**
     * Count the number of anchors and group them by type.
     *
     * @param object $xpath An XPATH object of the current document.
     *
     * @return array
     */
    private function get_anchor_count(&$xpath) {
        $query       = '//a|//A';
        $dom_objects = $xpath->query($query);
    
        $count = array(
                'total'    => 0,
                'internal' => array('nofollow' => 0, 'dofollow' => 0),
                'external' => array('nofollow' => 0, 'dofollow' => 0),
                'other'    => array('nofollow' => 0, 'dofollow' => 0),
        );
    
        if (is_object($dom_objects) && is_a($dom_objects, 'DOMNodeList') && $dom_objects->length > 0) {
            foreach ($dom_objects as $dom_object) {
                $count['total'] ++;
                if ($dom_object->attributes->getNamedItem('href')) {
                    $href  = $dom_object->attributes->getNamedItem('href')->textContent;
                    
                    if(stristr($href, System::getBaseUrl())){
                        $type = 'internal';
                    } elseif (substr($href, 0, 4) == 'http') {
                        $type = 'external';
                    } else {
                        $type = 'other';
                    }
    
                    if ($dom_object->attributes->getNamedItem('rel')) {
                        $link_rel = $dom_object->attributes->getNamedItem('rel')->textContent;
                        if (stripos($link_rel, 'nofollow') !== false) {
                            $count[$type]['nofollow'] ++;
                        } else {
                            $count[$type]['dofollow'] ++;
                        }
                    } else {
                        $count[$type]['dofollow'] ++;
                    }
                }
            }
        }
    
        return $count;
    }
    
    /**
     * Score the headings for keyword appearance.
     *
     * @param array $job      The array holding the keywords.
     * @param array $results  The results array.
     * @param array $headings The headings found in the document.
     */
    private function score_headings($headings) {    
        $headingCount = count($headings);
        if ($headingCount == 0) {
            $this->save_score_result(7, $this->__('No subheading tags (like an H2) appear in the copy.'), 'headings');
        } else {
            $found = 0;
            foreach ($headings as $heading) {
                $haystack1 = $this->strip_separators_and_fold($heading, true);
                $haystack2 = $this->strip_separators_and_fold($heading, false);
    
                if (strrpos($haystack1, $this->keywordFolded) !== false) {
                    $found ++;
                } elseif (strrpos($haystack2, $this->keywordFolded) !== false) {
                    $found ++;
                }
            }
            if ($found) {
                $this->save_score_result(9, $this->__f('Keyword / keyphrase appears in %s (out of %s) subheadings in the copy. While not a major ranking factor, this is beneficial.', array($found, $headingCount)), 'headings');
            } else {
                $this->save_score_result(3, $this->__('You have not used your keyword / keyphrase in any subheading (such as an H2) in your copy.'), 'headings');
            }
        }
    }

    /**
     * Check whether the images alt texts contain the keyword.
     *
     * @param array $job     The job array holding both the keyword versions.
     * @param array $results The results array.
     * @param array $imgs    The array with images alt texts.
     */
    private function score_images_alt_text($imgs) {
        if ($imgs['count'] == 0) {
            $this->save_score_result(3, $this->__('No images appear in this page, consider adding some as appropriate.'), 'images_alt');
        } elseif (count($imgs['alts']) == 0 && $imgs['count'] != 0) {
            $this->save_score_result(5, $this->__('The images on this page are missing alt tags.'), 'images_alt');
        } else {
            $found = false;
            foreach ($imgs['alts'] as $alt) {
                $haystack1 = $this->strip_separators_and_fold($alt, true);
                $haystack2 = $this->strip_separators_and_fold($alt, false);
                if (strrpos($haystack1, $this->keywordFolded) !== false) {
                    $found = true;
                } elseif (strrpos($haystack2, $this->keywordFolded) !== false) {
                    $found = true;
                }
            }
            if ($found) {
                $this->save_score_result(9, $this->__('The images on this page contain alt tags with the target keyword / phrase.'), 'images_alt');
            } else {
                $this->save_score_result(5, $this->__('The images on this page do not have alt tags containing your keyword / phrase.'), 'images_alt');
            }
        }
    }
    
    /**
     * Clean up the input string.
     *
     * @param string $inputString              String to clean up.
     * @param bool   $removeOptionalCharacters Whether or not to do a cleanup of optional chars too.
     *
     * @return string
     */
    private function strip_separators_and_fold($inputString, $removeOptionalCharacters = false) {    
        // lower
        $inputString = strtolower($inputString);
    
        // default characters replaced by space
        $inputString = str_replace(array(',', "'", '"', '?', '’', '“', '”', '|', '/'), ' ', $inputString);
    
        // standardise whitespace
        $inputString = $this->standardize_whitespace($inputString);
    
        // deal with the separators that can be either removed or replaced by space
        if ($removeOptionalCharacters) {
            // remove word separators with a space
            $inputString = str_replace(array(' a ', ' in ', ' an ', ' on ', ' for ', ' the ', ' and '), ' ', $inputString);
    
            $inputString = str_replace(array('_', '-'), '', $inputString);
        } else {
            $inputString = str_replace(array('_', '-'), ' ', $inputString);
        }
    
        // standardise whitespace again
        $inputString = $this->standardize_whitespace($inputString);
    
        return trim($inputString);
    }
    
    /**
     * Standardize whitespace in a string
     *
     * Replace line breaks, carriage returns, tabs with a space, then remove double spaces.
     *
     * @static
     *
     * @param string $string
     *
     * @return string
     */
    private function standardize_whitespace($string) {
        return trim(str_replace('  ', ' ', str_replace(array("\t", "\n", "\r", "\f"), ' ', $string)));
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
    private function calc($number1, $action, $number2, $round = false, $decimals = 0, $precision = 10) {
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
    
    /**
     * Sort an array by a given key.
     *
     * @param array  $array Array to sort, array is returned sorted.
     * @param string $key   Key to sort array by.
     */
    function aasort(&$array, $key) {
        $sorter = array();
        $ret    = array();
        reset($array);
        foreach ($array as $ii => $va) {
            $sorter[$ii] = $va[$key];
        }
        asort($sorter);
        foreach ($sorter as $ii => $va) {
            $ret[$ii] = $array[$ii];
        }
        $array = $ret;
    }
}