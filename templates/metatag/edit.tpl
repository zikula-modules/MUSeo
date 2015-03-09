{* purpose of this template: build the Form to edit an instance of metatag *}
{assign var='lct' value='user'}
{if isset($smarty.get.lct) && $smarty.get.lct eq 'admin'}
    {assign var='lct' value='admin'}
{/if}
{include file="`$lct`/header.tpl"}
{pageaddvar name='javascript' value='modules/MUSeo/javascript/MUSeo_editFunctions.js'}
{pageaddvar name='javascript' value='modules/MUSeo/javascript/MUSeo_validation.js'}

{if $mode eq 'edit'}
    {gt text='Edit metatag' assign='templateTitle'}
    {if $lct eq 'admin'}
        {assign var='adminPageIcon' value='edit'}
    {/if}
{elseif $mode eq 'create'}
    {gt text='Create metatag' assign='templateTitle'}
    {if $lct eq 'admin'}
        {assign var='adminPageIcon' value='new'}
    {/if}
{else}
    {gt text='Edit metatag' assign='templateTitle'}
    {if $lct eq 'admin'}
        {assign var='adminPageIcon' value='edit'}
    {/if}
{/if}
<div class="museo-metatag museo-edit">
    {pagesetvar name='title' value=$templateTitle}
    {if $lct eq 'admin'}
        <div class="z-admin-content-pagetitle">
            {icon type=$adminPageIcon size='small' alt=$templateTitle}
            <h3>{$templateTitle}</h3>
        </div>
    {else}
        <h2>{$templateTitle}</h2>
    {/if}
    
{pageaddvar name='javascript' value='prototype'}
{pageaddvarblock name='header'}
    <script type="text/javascript">               
        Event.observe(window, 'load', function() {     
            function iframeRef(frameRef)
            {
                return frameRef.contentWindow ? frameRef.contentWindow.document : frameRef.contentDocument;
            }

            function evaluateKeyword()
            {
                var focuskw = yst_escapeFocusKw(String.trim($F('focusKeyword'))).toLowerCase();
                if (focuskw == '') {
                    return;
                }

                var seoFrameObj, seoFrame;
                seoFrameObj = document.getElementById('seoFrame');
                if (seoFrameObj !== undefined) {
                    seoFrame = iframeRef(seoFrameObj);
                }
                var p = new RegExp("(^|[ \s\n\r\t\.,'\(\"\+;!?:\-])" + focuskw + "($|[ \s\n\r\t.,'\)\"\+!?:;\-])", 'gim');
                //remove diacritics of a lower cased focuskw for url matching in foreign lang
                var focuskwNoDiacritics = removeLowerCaseDiacritics(focuskw);
                var p2 = new RegExp(focuskwNoDiacritics.replace(/\s+/g, "[-_\\\//]"), 'gim');                            

                $('focuskwresultsPageTitle').update(ptest(seoFrame.title, p));
                $('focuskwresultsPageURL').update(ptest(seoFrame.URL, p2));
                $('focuskwresultsPageContent').update(ptest(seoFrame.getElementsByTagName("body")[0].innerHTML, p));

                var metaDescription;
                var metas = seoFrame.getElementsByTagName('meta');
                if (metas) {
                    for (var x = 0, y = metas.length; x < y; x++) {
                        if (metas[x].name.toLowerCase() == 'keywords') {
                             //console.log('Keywords ' + ptest(metas[x].content, p));
                             $('focuskwresultsMetaKeywords').update(ptest(metas[x].content, p));
                        } else if (metas[x].name.toLowerCase() == 'description') {
                            metaDescription = metas[x].content;
                            $('focuskwresultsMetaDescription').update(ptest(metas[x].content, p));
                        }
                    }
                }
                
                var title = null, url = null, description = null;
                if (fieldIdTitle !== undefined && fieldIdTitle !== null && fieldIdTitle !== '') {
                    title = $F(fieldIdTitle);
                } else if (seoFrame !== null) {
                    title = seoFrame.title;
                }
                
                if (fieldIdUrl !== undefined && fieldIdUrl !== null && fieldIdUrl !== '') {
                    url = $F(fieldIdUrl);
                } else if (seoFrame !== null) {
                    url = seoFrame.URL;
                }
                
                if (fieldIdDescription !== undefined && fieldIdDescription !== null && fieldIdDescription !== '') {
                    description = $F(fieldIdDescription);
                } else if (seoFrame !== null) {
                    description = metaDescription;
                }

                if (title === null || url === null || description == null) {
                    $('snippetPreview').update('');
                } else {
                    $('snippetPreview').update('<a class="title" href="#">' + yst_boldKeywords(title, false) + '</a><span class="url">' + yst_boldKeywords(url, true) + '</span><p class="desc"><span class="content">' + yst_trimDesc(yst_boldKeywords(description, false)) + '</span></p>');
                }
            }

            evaluateKeyword();

            $('focusKeyword').observe('change', function() {
                evaluateKeyword();
            });
        });
    </script>
{/pageaddvarblock}

{if isset($smarty.get.currentUrl) && $smarty.get.currentUrl ne ''}
    <iframe id="seoFrame" src="{$smarty.get.currentUrl}" style="display: none">
    </iframe>
{/if}


    {form enctype='multipart/form-data' cssClass='z-form'}
        {* add validation summary and a <div> element for styling the form *}
        {museoFormFrame}
        {formsetinitialfocus inputId='titleOfEntity'}
        {formtabbedpanelset}
            {gt text='General' assign='tabTitle'}
            {formtabbedpanel title=$tabTitle}

            <fieldset>
                <legend>{gt text='Content'}</legend>
                
                <div class="z-formrow">
                    {gt text='Enter the title of this entity; so you can find it!' assign='toolTip'}
                    {formlabel for='titleOfEntity' __text='Title of entity' mandatorysym='1' cssClass='museo-form-tooltips' title=$toolTip}
                    {formtextinput group='metatag' id='titleOfEntity' mandatory=true readOnly=false __title='Enter the title of entity of the metatag' textMode='singleline' maxLength=255 cssClass='required' }
                    {museoValidationError id='titleOfEntity' class='required'}
                    <span class="z-formnote">{$toolTip}</span>
                </div>
                
                <div class="z-formrow">
                    {gt text='The main keyword or keyphrase that this post/page is about' assign='toolTip'}
                    {formlabel for='focusKeyword' __text='Focus keyword' cssClass='museo-form-tooltips' title=$toolTip}
                    <div>
                        {formtextinput group='metatag' id='focusKeyword' mandatory=false readOnly=false __title='Enter the focus keyword of the metatag' textMode='singleline' maxLength=255 cssClass='' }
                        <span class="z-formnote">{$toolTip}</span>
                        <div class="z-formnote" id="focuskwresults">
                            {gt text='Your focus keyword was found in'}:<br />
                            {gt text='Page title'}: <span id="focuskwresultsPageTitle"></span><br />
                            {gt text='Page URL'}: <span id="focuskwresultsPageURL"></span><br />
                            {gt text='Page Content'}: <span id="focuskwresultsPageContent"></span><br />
                            {gt text='Meta keywords'}: <span id="focuskwresultsMetaKeywords"></span><br />
                            {gt text='Meta description'}: <span id="focuskwresultsMetaDescription"></span><br />
                        </div>
                    </div>
                </div>

                <div class="z-formrow">
                    <label title="" class="museo-form-tooltips" for="focusKeyword">{gt text='Snippet Preview'}</label>
                    <div id="snippetPreview">
                    </div>
                    <span class="z-formnote">{gt text='This is a rendering of what this page might look like in Google\'s search results.'}</span>
                </div>

                <div class="z-formrow">
                    {gt text='SEO title' assign='toolTip'}
                    {formlabel for='title' __text='Title' cssClass='museo-form-tooltips' title=$toolTip}
                    {formtextinput group='metatag' id='title' mandatory=false readOnly=false __title='Enter the title of the metatag' textMode='singleline' maxLength=255 cssClass='' }
                    <span class="z-formnote">{gt text='The SEO title defaults to what is generated based on this sites title template for this posttype.'}</span>
                </div>

                <div class="z-formrow">
                    {gt text='Meta description' assign='toolTip'}
                    {formlabel for='description' __text='Description' cssClass='museo-form-tooltips' title=$toolTip}
                    {formtextinput group='metatag' id='description' mandatory=false readOnly=false __title='Enter the description of the metatag' textMode='singleline' maxLength=255 cssClass='' }
                    <span class="z-formnote">{gt text='The meta description is often shown as the black text under the title in a search result. For this to work it has to contain the keyword that was searched for.'}</span>
                </div>

                <div class="z-formrow">
                    {gt text='Comma separated list of meta keywords - for example: Zikula, Framework' assign='toolTip'}
                    {formlabel for='keywords' __text='Keywords' cssClass='museo-form-tooltips' title=$toolTip}
                    {formtextinput group='metatag' id='keywords' mandatory=false readOnly=false __title='Enter the keywords of the metatag' textMode='singleline' maxLength=255 cssClass='' }
                    <span class="z-formnote">{$toolTip} {gt text='If you type something here it will override your meta keywords template.'}</span>
                </div>
            </fieldset>
            <fieldset class="z-hide">
                <legend>{gt text='Analysis'}</legend>
                <div class="z-formrow">
                    {formlabel for='pageAnalysisScore' __text='Page analysis score' cssClass=''}
                    {formintinput group='metatag' id='pageAnalysisScore' mandatory=false __title='Enter the page analysis score of the metatag' maxLength=11 cssClass=' validate-digits' }
                    {museoValidationError id='pageAnalysisScore' class='validate-digits'}
                </div>
            </fieldset>
            {/formtabbedpanel}
            
            {modgetvar module='MUSeo' name='disableAdvancedMeta' assign='disableAdvancedMeta'}
            
            {if $disableAdvancedMeta eq false}
                {gt text='Advanced' assign='tabTitle'}
                {formtabbedpanel title=$tabTitle}
                <fieldset>
                    <div class="z-formrow">
                        {gt text='Meta robots index' assign='toolTip'}
                        {formlabel for='robotsIndex' __text='Robots index' cssClass='museo-form-tooltips' title=$toolTip}
                        {formdropdownlist group='metatag' id='robotsIndex' mandatory=false __title='Choose the robots index' selectionMode='single'}
                        <span class="z-formnote z-errormsg">{gt text='Warning: even though you can set the meta robots setting here, the entire site is set to noindex in the sitewide privacy settings, so these settings won\'t have an effect.'}</span>
                    </div>
                    
                    <div class="z-formrow">
                        {gt text='Meta robots follow' assign='toolTip'}
                        {formlabel for='robotsFollow' __text='Robots follow' cssClass='museo-form-tooltips' title=$toolTip}
                        {formdropdownlist group='metatag' id='robotsFollow' mandatory=false __title='Choose the robots follow' selectionMode='single'}
                        <span class="z-formnote">{$toolTip}</span>
                    </div>
                    
                    <div class="z-formrow">
                        {formlabel for='robotsAdvanced' __text='Robots advanced' cssClass=''}
                        {formdropdownlist group='metatag' id='robotsAdvanced' mandatory=false __title='Choose the robots advanced' selectionMode='multiple'}
                        <span class="z-formnote">{gt text='Advanced <code>meta</code> robots settings for this page.'}</span>
                    </div>
                    
                    <div class="z-formrow">
                        {gt text='Canonical url' assign='toolTip'}
                        {formlabel for='canonicalUrl' __text='Canonical url' cssClass='museo-form-tooltips' title=$toolTip}
                        {formurlinput group='metatag' id='canonicalUrl' mandatory=false readOnly=false __title='Enter the canonical url of the metatag' textMode='singleline' maxLength=255 cssClass=' validate-url' }
                        {museoValidationError id='canonicalUrl' class='validate-url'}
                        <span class="z-formnote">{gt text='The canonical URL that this page should point to, leave blank to default to permalink. <a target="_blank" href="http://googlewebmastercentral.blogspot.com/2009/12/handling-legitimate-cross-domain.html">Cross domain canonical</a> supported too.'}</span>
                    </div>
                    
                    <div class="z-formrow">
                        {gt text='301 redirect url' assign='toolTip'}
                        {formlabel for='redirectUrl' __text='Redirect url' cssClass='museo-form-tooltips' title=$toolTip}
                        {formurlinput group='metatag' id='redirectUrl' mandatory=false readOnly=false __title='Enter the redirect url of the metatag' textMode='singleline' maxLength=255 cssClass=' validate-url' }
                        {museoValidationError id='redirectUrl' class='validate-url'}
                        <span class="z-formnote">{gt text='The URL that this page should redirect to.'}</span>
                    </div>
                    
                </fieldset>
                {/formtabbedpanel}
            {/if}
            
            {gt text='Social media' assign='tabTitle'}
            {formtabbedpanel title=$tabTitle}
            <fieldset>
                <legend>{gt text='Facebook'}</legend>
                <div class="z-formrow">
                    {gt text='Facebook title overriding the default value' assign='toolTip'}
                    {formlabel for='facebookTitle' __text='Facebook title' cssClass='museo-form-tooltips' title=$toolTip}
                    {formtextinput group='metatag' id='facebookTitle' mandatory=false readOnly=false __title='Enter the facebook title of the metatag' textMode='singleline' maxLength=255 cssClass='' }
                    <span class="z-formnote">{gt text='If you don\'t want to use the post title for sharing the post on Facebook but instead want another title there, write it here.'}</span>
                </div>
                
                <div class="z-formrow">
                    {gt text='Facebook description overriding the default value' assign='toolTip'}
                    {formlabel for='facebookDescription' __text='Facebook description' cssClass='museo-form-tooltips' title=$toolTip}
                    {formtextinput group='metatag' id='facebookDescription' mandatory=false __title='Enter the facebook description of the metatag' textMode='multiline' rows='6' cols='50' cssClass='' }
                    <span class="z-formnote">{gt text='If you don\'t want to use the meta description for sharing the post on Facebook but want another description there, write it here.'}</span>
                </div>
                
                <div class="z-formrow">
                    {gt text='Facebook image overriding the default value' assign='toolTip'}
                    {formlabel for='facebookImage' __text='Facebook image' cssClass='museo-form-tooltips' title=$toolTip}<br />{* break required for Google Chrome *}
                    {formuploadinput group='metatag' id='facebookImage' mandatory=false readOnly=false cssClass=' validate-upload' }
                    <span class="z-formnote">{gt text='If you want to override the image used on Facebook for this post, upload an image here.'}</span>
                    <span class="z-formnote z-sub"><a id="resetFacebookImageVal" href="javascript:void(0);" class="z-hide" style="clear:left;">{gt text='Reset to empty value'}</a></span>
                    
                        <span class="z-formnote">{gt text='Allowed file extensions:'} <span id="facebookImageFileExtensions">gif, jpeg, jpg, png</span></span>
                    {if $mode ne 'create'}
                        {if $metatag.facebookImage ne ''}
                            <span class="z-formnote">
                                {gt text='Current file'}:
                                <a href="{$metatag.facebookImageFullPathUrl}" title="{$formattedEntityTitle|replace:"\"":""}"{if $metatag.facebookImageMeta.isImage} rel="imageviewer[metatag]"{/if}>
                                {if $metatag.facebookImageMeta.isImage}
                                    {thumb image=$metatag.facebookImageFullPath objectid="metatag-`$metatag.id`" preset=$metatagThumbPresetFacebookImage tag=true img_alt=$formattedEntityTitle}
                                {else}
                                    {gt text='Download'} ({$metatag.facebookImageMeta.size|museoGetFileSize:$metatag.facebookImageFullPath:false:false})
                                {/if}
                                </a>
                            </span>
                            <span class="z-formnote">
                                {formcheckbox group='metatag' id='facebookImageDeleteFile' readOnly=false __title='Delete facebook image ?'}
                                {formlabel for='facebookImageDeleteFile' __text='Delete existing file'}
                            </span>
                        {/if}
                    {/if}
                    {museoValidationError id='facebookImage' class='validate-upload'}
                </div>
            </fieldset>
            <fieldset>
                <legend>{gt text='Twitter'}</legend>
                <div class="z-formrow">
                    {gt text='Twitter title overriding the default value' assign='toolTip'}
                    {formlabel for='twitterTitle' __text='Twitter title' cssClass='museo-form-tooltips' title=$toolTip}
                    {formtextinput group='metatag' id='twitterTitle' mandatory=false readOnly=false __title='Enter the twitter title of the metatag' textMode='singleline' maxLength=255 cssClass='' }
                    <span class="z-formnote">{gt text='If you don\'t want to use the post title for sharing the post on Twitter but instead want another title there, write it here.'}</span>
                </div>
                
                <div class="z-formrow">
                    {gt text='Twitter description overriding the default value' assign='toolTip'}
                    {formlabel for='twitterDescription' __text='Twitter description' cssClass='museo-form-tooltips' title=$toolTip}
                    {formtextinput group='metatag' id='twitterDescription' mandatory=false __title='Enter the twitter description of the metatag' textMode='multiline' rows='6' cols='50' cssClass='' }
                    <span class="z-formnote">{gt text='If you don\'t want to use the meta description for sharing the post on Twitter but want another description there, write it here.'}</span>
                </div>
                
                <div class="z-formrow">
                    {gt text='Twitter image overriding the default value' assign='toolTip'}
                    {formlabel for='twitterImage' __text='Twitter image' cssClass='museo-form-tooltips' title=$toolTip}<br />{* break required for Google Chrome *}
                    {formuploadinput group='metatag' id='twitterImage' mandatory=false readOnly=false cssClass=' validate-upload' }
                    <span class="z-formnote">{gt text='If you want to override the image used on Twitter for this post, upload an image here.'}</span>
                    <span class="z-formnote z-sub"><a id="resetTwitterImageVal" href="javascript:void(0);" class="z-hide" style="clear:left;">{gt text='Reset to empty value'}</a></span>
                    
                        <span class="z-formnote">{gt text='Allowed file extensions:'} <span id="twitterImageFileExtensions">gif, jpeg, jpg, png</span></span>
                    {if $mode ne 'create'}
                        {if $metatag.twitterImage ne ''}
                            <span class="z-formnote">
                                {gt text='Current file'}:
                                <a href="{$metatag.twitterImageFullPathUrl}" title="{$formattedEntityTitle|replace:"\"":""}"{if $metatag.twitterImageMeta.isImage} rel="imageviewer[metatag]"{/if}>
                                {if $metatag.twitterImageMeta.isImage}
                                    {thumb image=$metatag.twitterImageFullPath objectid="metatag-`$metatag.id`" preset=$metatagThumbPresetTwitterImage tag=true img_alt=$formattedEntityTitle}
                                {else}
                                    {gt text='Download'} ({$metatag.twitterImageMeta.size|museoGetFileSize:$metatag.twitterImageFullPath:false:false})
                                {/if}
                                </a>
                            </span>
                            <span class="z-formnote">
                                {formcheckbox group='metatag' id='twitterImageDeleteFile' readOnly=false __title='Delete twitter image ?'}
                                {formlabel for='twitterImageDeleteFile' __text='Delete existing file'}
                            </span>
                        {/if}
                    {/if}
                    {museoValidationError id='twitterImage' class='validate-upload'}
                </div>
            </fieldset>
            <fieldset>
                <legend>{gt text='Google+'}</legend>
                
                <div class="z-formrow">
                    {gt text='Google+ title overriding the default value' assign='toolTip'}
                    {formlabel for='googlePlusTitle' __text='Google plus title' cssClass='museo-form-tooltips' title=$toolTip}
                    {formtextinput group='metatag' id='googlePlusTitle' mandatory=false readOnly=false __title='Enter the google plus title of the metatag' textMode='singleline' maxLength=255 cssClass='' }
                    <span class="z-formnote">{gt text='If you don\'t want to use the post title for sharing the post on Google+ but instead want another title there, write it here.'}</span>
                </div>
                
                <div class="z-formrow">
                    {gt text='Google+ description overriding the default value' assign='toolTip'}
                    {formlabel for='googlePlusDescription' __text='Google plus description' cssClass='museo-form-tooltips' title=$toolTip}
                    {formtextinput group='metatag' id='googlePlusDescription' mandatory=false __title='Enter the google plus description of the metatag' textMode='multiline' rows='6' cols='50' cssClass='' }
                    <span class="z-formnote">{gt text='If you don\'t want to use the meta description for sharing the post on Google+ but want another description there, write it here.'}</span>
                </div>
                
                <div class="z-formrow">
                    {gt text='Google+ image overriding the default value' assign='toolTip'}
                    {formlabel for='googlePlusImage' __text='Google plus image' cssClass='museo-form-tooltips' title=$toolTip}<br />{* break required for Google Chrome *}
                    {formuploadinput group='metatag' id='googlePlusImage' mandatory=false readOnly=false cssClass=' validate-upload' }
                    <span class="z-formnote">{gt text='If you want to override the image used on Google+ for this post, upload an image here.'}</span>
                    <span class="z-formnote z-sub"><a id="resetGooglePlusImageVal" href="javascript:void(0);" class="z-hide" style="clear:left;">{gt text='Reset to empty value'}</a></span>
                    
                        <span class="z-formnote">{gt text='Allowed file extensions:'} <span id="googlePlusImageFileExtensions">gif, jpeg, jpg, png</span></span>
                    {if $mode ne 'create'}
                        {if $metatag.googlePlusImage ne ''}
                            <span class="z-formnote">
                                {gt text='Current file'}:
                                <a href="{$metatag.googlePlusImageFullPathUrl}" title="{$formattedEntityTitle|replace:"\"":""}"{if $metatag.googlePlusImageMeta.isImage} rel="imageviewer[metatag]"{/if}>
                                {if $metatag.googlePlusImageMeta.isImage}
                                    {thumb image=$metatag.googlePlusImageFullPath objectid="metatag-`$metatag.id`" preset=$metatagThumbPresetGooglePlusImage tag=true img_alt=$formattedEntityTitle}
                                {else}
                                    {gt text='Download'} ({$metatag.googlePlusImageMeta.size|museoGetFileSize:$metatag.googlePlusImageFullPath:false:false})
                                {/if}
                                </a>
                            </span>
                            <span class="z-formnote">
                                {formcheckbox group='metatag' id='googlePlusImageDeleteFile' readOnly=false __title='Delete google plus image ?'}
                                {formlabel for='googlePlusImageDeleteFile' __text='Delete existing file'}
                            </span>
                        {/if}
                    {/if}
                    {museoValidationError id='googlePlusImage' class='validate-upload'}
                </div>
            </fieldset>
            <fieldset>
                <legend>{gt text='WhatsApp'}</legend>
                <div class="z-formrow">
                    {gt text='WhatsApp title overriding the default value' assign='toolTip'}
                    {formlabel for='whatsAppTitle' __text='Whats app title' cssClass='museo-form-tooltips' title=$toolTip}
                    {formtextinput group='metatag' id='whatsAppTitle' mandatory=false readOnly=false __title='Enter the whats app title of the metatag' textMode='singleline' maxLength=255 cssClass='' }
                </div>
            </fieldset>
            {/formtabbedpanel}
            
            {gt text='Integration' assign='tabTitle'}
            {formtabbedpanel title=$tabTitle}
            <fieldset>
                <div class="z-formrow">
                    {gt text='Select the module!' assign='toolTip'}
                    {formlabel for='theModule' __text='The module' mandatorysym='1' cssClass='museo-form-tooltips' title=$toolTip}
                    {formtextinput group='metatag' id='theModule' mandatory=true readOnly=false __title='Enter the module of the metatag' textMode='singleline' maxLength=50 cssClass='required' }
                    {museoValidationError id='theModule' class='required'}
                    <span class="z-formnote">{$toolTip}</span>
                </div>
                
                <div class="z-formrow">
                    {gt text='Enter the function of your selected module!' assign='toolTip'}
                    {formlabel for='functionOfModule' __text='Function of module' mandatorysym='1' cssClass='museo-form-tooltips' title=$toolTip}
                    {formtextinput group='metatag' id='functionOfModule' mandatory=true readOnly=false __title='Enter the function of module of the metatag' textMode='singleline' maxLength=50 cssClass='required' }
                    {museoValidationError id='functionOfModule' class='required'}
                    <span class="z-formnote">{$toolTip}</span>
                </div>
                
                <div class="z-formrow">
                    {gt text='Enter the object of your selected module; if not set it will work for the main function!' assign='toolTip'}
                    {formlabel for='objectOfModule' __text='Object of module' cssClass='museo-form-tooltips' title=$toolTip}
                    {formtextinput group='metatag' id='objectOfModule' mandatory=false readOnly=false __title='Enter the object of module of the metatag' textMode='singleline' maxLength=50 cssClass='' }
                    <span class="z-formnote">{$toolTip}</span>
                </div>
                
                <div class="z-formrow">
                    {gt text='Enter the name for the single identifier! For example id!' assign='toolTip'}
                    {formlabel for='nameOfIdentifier' __text='Name of identifier' cssClass='museo-form-tooltips' title=$toolTip}
                    {formtextinput group='metatag' id='nameOfIdentifier' mandatory=false readOnly=false __title='Enter the name of identifier of the metatag' textMode='singleline' maxLength=20 cssClass='' }
                    <span class="z-formnote">{$toolTip}</span>
                </div>
                
                <div class="z-formrow">
                    {gt text='Enter the id of your selected module; only required if you have entered a function that calls a single entity!' assign='toolTip'}
                    {formlabel for='idOfObject' __text='Id of object' cssClass='museo-form-tooltips' title=$toolTip}
                    {formintinput group='metatag' id='idOfObject' mandatory=false __title='Enter the id of object of the metatag' maxLength=11 cssClass=' validate-digits' }
                    {museoValidationError id='idOfObject' class='validate-digits'}
                    <span class="z-formnote">{$toolTip}</span>
                </div>

                <div class="z-formrow">
                    {gt text='Enter the string of an object! For example Zikula!' assign='toolTip'}
                    {formlabel for='stringOfObject' __text='String of object' cssClass='museo-form-tooltips' title=$toolTip}
                    {formtextinput group='metatag' id='stringOfObject' mandatory=false readOnly=false __title='Enter the string of object of the metatag' textMode='singleline' maxLength=50 cssClass='' }
                    <span class="z-formnote">{$toolTip}</span>
                </div>

                <div class="z-formrow">
                    {gt text='Enter other parameters and their values comma separated like parameter1=value1,parameter2=value!' assign='toolTip'}
                    {formlabel for='extraInfos' __text='Extra infos' cssClass='museo-form-tooltips' title=$toolTip}
                    {formtextinput group='metatag' id='extraInfos' mandatory=false readOnly=false __title='Enter the extra infos of the metatag' textMode='singleline' maxLength=255 cssClass='' }
                    <span class="z-formnote">{$toolTip}</span>
                </div>
            </fieldset>
        {/formtabbedpanel}
    {/formtabbedpanelset}


        {if $mode ne 'create'}
            {include file='helper/include_standardfields_edit.tpl' obj=$metatag}
        {/if}
        
        {* include display hooks *}
        {if $mode ne 'create'}
            {assign var='hookId' value=$metatag.id}
            {notifydisplayhooks eventname='museo.ui_hooks.metatags.form_edit' id=$hookId assign='hooks'}
        {else}
            {notifydisplayhooks eventname='museo.ui_hooks.metatags.form_edit' id=null assign='hooks'}
        {/if}
        {if is_array($hooks) && count($hooks)}
            {foreach name='hookLoop' key='providerArea' item='hook' from=$hooks}
                {if $providerArea ne 'provider.scribite.ui_hooks.editor'}{* fix for #664 *}
                    <fieldset>
                        {$hook}
                    </fieldset>
                {/if}
            {/foreach}
        {/if}
        
        
        {* include return control *}
        {if $mode eq 'create'}
            <fieldset>
                <legend>{gt text='Return control'}</legend>
                <div class="z-formrow">
                    {formlabel for='repeatCreation' __text='Create another item after save'}
                        {formcheckbox group='metatag' id='repeatCreation' readOnly=false}
                </div>
            </fieldset>
        {/if}
        
        {* include possible submit actions *}
        <div class="z-buttons z-formbuttons">
        {foreach item='action' from=$actions}
            {assign var='actionIdCapital' value=$action.id|@ucfirst}
            {gt text=$action.title assign='actionTitle'}
            {*gt text=$action.description assign='actionDescription'*}{* TODO: formbutton could support title attributes *}
            {if $action.id eq 'delete'}
                {gt text='Really delete this metatag?' assign='deleteConfirmMsg'}
                {formbutton id="btn`$actionIdCapital`" commandName=$action.id text=$actionTitle class=$action.buttonClass confirmMessage=$deleteConfirmMsg}
            {else}
                {formbutton id="btn`$actionIdCapital`" commandName=$action.id text=$actionTitle class=$action.buttonClass}
            {/if}
        {/foreach}
        {formbutton id='btnCancel' commandName='cancel' __text='Cancel' class='z-bt-cancel'}
        </div>
        {/museoFormFrame}
    {/form}
</div>
{include file="`$lct`/footer.tpl"}

{icon type='edit' size='extrasmall' assign='editImageArray'}
{icon type='delete' size='extrasmall' assign='removeImageArray'}


<script type="text/javascript">
/* <![CDATA[ */
    
    var formButtons, formValidator;
    
    function handleFormButton (event) {
        var result = formValidator.validate();
        if (!result) {
            // validation error, abort form submit
            Event.stop(event);
        } else {
            // hide form buttons to prevent double submits by accident
            formButtons.each(function (btn) {
                btn.addClassName('z-hide');
            });
        }
    
        return result;
    }
    
    document.observe('dom:loaded', function() {
    
        mUMUSeoAddCommonValidationRules('metatag', '{{if $mode ne 'create'}}{{$metatag.id}}{{/if}}');
        {{* observe validation on button events instead of form submit to exclude the cancel command *}}
        formValidator = new Validation('{{$__formid}}', {onSubmit: false, immediate: true, focusOnError: false});
        {{if $mode ne 'create'}}
            var result = formValidator.validate();
        {{/if}}
    
        formButtons = $('{{$__formid}}').select('div.z-formbuttons input');
    
        formButtons.each(function (elem) {
            if (elem.id != 'btnCancel') {
                elem.observe('click', handleFormButton);
            }
        });
    
        Zikula.UI.Tooltips($$('.museo-form-tooltips'));
        mUMUSeoInitUploadField('facebookImage');
        mUMUSeoInitUploadField('twitterImage');
        mUMUSeoInitUploadField('googlePlusImage');
    });
/* ]]> */
</script>
