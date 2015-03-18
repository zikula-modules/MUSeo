{* purpose of this template: module configuration *}
{include file='admin/header.tpl'}
<div class="museo-config">
    {gt text='Settings' assign='templateTitle'}
    {pagesetvar name='title' value=$templateTitle}
    <div class="z-admin-content-pagetitle">
        {icon type='config' size='small' __alt='Settings'}
        <h3>{$templateTitle}</h3>
    </div>

    {form cssClass='z-form'}
        {* add validation summary and a <div> element for styling the form *}
        {museoFormFrame}
            {formsetinitialfocus inputId='modules'}
            {formtabbedpanelset}
                {gt text='General' assign='tabTitle'}
                {formtabbedpanel title=$tabTitle}
                    <fieldset>
                        <legend>{$tabTitle}</legend>
                    
                        <p class="z-confirmationmsg">{gt text='Here you can define general settings.'|nl2br}</p>
                    
                        <div class="z-formrow">
                            {gt text='Enter the allowed modules comma separated without whitespace, for example: Content,Tags,News' assign='toolTip'}
                            {formlabel for='modules' __text='Modules' cssClass='museo-form-tooltips ' title=$toolTip}
                            {formtextinput id='modules' group='config' maxLength=255 __title='Enter the modules.'}
                            <span class="z-formnote">{$toolTip}</span>
                        </div>
                        <div class="z-formrow">
                            {gt text='Enter the allowed controllers comma separated without whitespace!' assign='toolTip'}
                            {formlabel for='controllers' __text='Controllers' cssClass='museo-form-tooltips ' title=$toolTip}
                            {formtextinput id='controllers' group='config' maxLength=255 __title='Enter the controllers.'}
                            <span class="z-formnote">{$toolTip}</span>
                        </div>
                    </fieldset>
                {/formtabbedpanel}
                {gt text='SEO' assign='tabTitle'}
                {formtabbedpanel title=$tabTitle}
                    <fieldset>
                        <legend>{$tabTitle}</legend>
                    
                        <p class="z-confirmationmsg">{gt text='Here you can adjust basic SEO-related options.'|nl2br}</p>
                    
                        <div class="z-formrow">
                            {gt text='Default meta robots index' assign='toolTip'}
                            {formlabel for='robotsIndex' __text='Robots index' cssClass='museo-form-tooltips ' title=$toolTip}
                            {formdropdownlist id='robotsIndex' group='config' __title='Choose the robots index'}
                            <span class="z-formnote">{$toolTip}</span>
                        </div>
                        <div class="z-formrow">
                            {gt text='Default meta robots follow' assign='toolTip'}
                            {formlabel for='robotsFollow' __text='Robots follow' cssClass='museo-form-tooltips ' title=$toolTip}
                            {formdropdownlist id='robotsFollow' group='config' __title='Choose the robots follow'}
                            <span class="z-formnote">{$toolTip}</span>
                        </div>
                        <div class="z-formrow">
                            {gt text='Disable the advanced part of the SEO meta box.' assign='toolTip'}
                            {formlabel for='disableAdvancedMeta' __text='Disable advanced meta' cssClass='museo-form-tooltips ' title=$toolTip}
                            {formcheckbox id='disableAdvancedMeta' group='config'}
                            <span class="z-formnote">{$toolTip}</span>
                        </div>
                        <div class="z-formrow">
                            {gt text='Add noodp meta robots tag sitewide' assign='toolTip'}
                            {formlabel for='noodp' __text='Noodp' cssClass='museo-form-tooltips ' title=$toolTip}
                            {formcheckbox id='noodp' group='config'}
                            <span class="z-formnote">{gt text='Prevents search engines from using the DMOZ description for pages from this site in the search results.'}</span>
                        </div>
                        <div class="z-formrow">
                            {gt text='Add noydir meta robots tag sitewide' assign='toolTip'}
                            {formlabel for='noydir' __text='Noydir' cssClass='museo-form-tooltips ' title=$toolTip}
                            {formcheckbox id='noydir' group='config'}
                            <span class="z-formnote">{gt text='Prevents search engines from using the Yahoo! directory description for pages from this site in the search results.'}</span>
                        </div>
                    </fieldset>  
                    <fieldset>
                        <legend>{gt text='Webmaster Tools'}</legend>

                        <p class="z-confirmationmsg">{gt text='You can use the boxes below to verify with the different Webmaster Tools, if your site is already verified, leave the boxes blank. Enter the verify meta values for:'|nl2br}</p>

                        <div class="z-formrow">
                            {gt text='Alexa Verification ID' assign='toolTip'}
                            {formlabel for='alexaVerify' __text='Alexa verify' cssClass='museo-form-tooltips ' title=$toolTip}
                            {formtextinput id='alexaVerify' group='config' maxLength=255 __title='Enter the alexa verify.'}
                            <span class="z-formnote"><a target="_blank" href="http://www.alexa.com/siteowners/claim">{gt text='Alexa Verification ID'}</a></span>
                        </div>
                        <div class="z-formrow">
                            {gt text='Google Webmaster Tools' assign='toolTip'}
                            {formlabel for='googleVerify' __text='Google verify' cssClass='museo-form-tooltips ' title=$toolTip}
                            {formtextinput id='googleVerify' group='config' maxLength=255 __title='Enter the google verify.'}
                            <span class="z-formnote"><a target="_blank" href="https://www.google.com/webmasters/verification/verification?hl=en&siteUrl={$baseurl|urlencode}/">{gt text='Google Webmaster Tools'}</a></span>
                        </div>
                        <div class="z-formrow">
                            {gt text='Bing Webmaster Tools' assign='toolTip'}
                            {formlabel for='msVerify' __text='Ms verify' cssClass='museo-form-tooltips ' title=$toolTip}
                            {formtextinput id='msVerify' group='config' maxLength=255 __title='Enter the ms verify.'}
                            <span class="z-formnote"><a target="_blank" href="http://www.bing.com/webmaster/?rfp=1#/Dashboard/?url={$baseurl|replace:'http://':''|replace:'https://':''|urlencode}">{gt text='Bing Webmaster Tools'}</a></span>
                        </div>
                        <div class="z-formrow">
                            {gt text='Pinterest' assign='toolTip'}
                            {formlabel for='pinterestVerify' __text='Pinterest verify' cssClass='museo-form-tooltips ' title=$toolTip}
                            {formtextinput id='pinterestVerify' group='config' maxLength=255 __title='Enter the pinterest verify.'}
                            <span class="z-formnote"><a target="_blank" href="https://help.pinterest.com/entries/22488487-Verify-with-HTML-meta-tags">{gt text='Pinterest'}</a></span>
                        </div>
                        <div class="z-formrow">
                            {gt text='Yandex Webmaster Tools' assign='toolTip'}
                            {formlabel for='yandexVerify' __text='Yandex verify' cssClass='museo-form-tooltips ' title=$toolTip}
                            {formtextinput id='yandexVerify' group='config' maxLength=255 __title='Enter the yandex verify.'}
                            <span class="z-formnote"><a target="_blank" href="http://help.yandex.com/webmaster/service/rights.xml#how-to">{gt text='Yandex Webmaster Tools'}</a></span>
                        </div>
                        <div class="z-formrow">
                            {gt text='Force the canonical to either http or https, when your site runs under both.' assign='toolTip'}
                            {formlabel for='forceTransport' __text='Force transport' cssClass='museo-form-tooltips ' title=$toolTip}
                            {formtextinput id='forceTransport' group='config' maxLength=10 __title='Enter the force transport.'}
                            <span class="z-formnote">{$toolTip}</span>
                        </div>
                    </fieldset>
                {/formtabbedpanel}
                {gt text='Social media' assign='tabTitle'}
                {formtabbedpanel title=$tabTitle}
                    <fieldset>
                        <legend>{gt text="Facebook"}</legend>
                    
                        <div class="z-formrow z-hide">
                            {gt text='List of user ids for Facebook administration' assign='toolTip'}
                            {formlabel for='facebookAdmins' __text='Facebook admins' cssClass='museo-form-tooltips ' title=$toolTip}
                            {formtextinput id='facebookAdmins' group='config' maxLength=255 __title='Enter the facebook admins.'}
                        </div>
                        <div class="z-formrow z-hide">
                            {gt text='List of linked Facebook apps IDs : Facebook app display names' assign='toolTip'}
                            {formlabel for='facebookApps' __text='Facebook apps' cssClass='museo-form-tooltips ' title=$toolTip}
                            {formtextinput id='facebookApps' group='config' maxLength=255 __title='Enter the facebook apps.'}
                        </div>
                        <div class="z-formrow z-hide">
                            {gt text='Facebook connect key' assign='toolTip'}
                            {formlabel for='facebookConnectKey' __text='Facebook connect key' cssClass='museo-form-tooltips ' title=$toolTip}
                            {formtextinput id='facebookConnectKey' group='config' maxLength=255 __title='Enter the facebook connect key.'}
                        </div>
                        <div class="z-formrow">
                            {gt text='Add Open Graph meta data to your site"s head section.' assign='toolTip'}
                            {formlabel for='openGraphEnabled' __text='Open graph enabled' cssClass='museo-form-tooltips ' title=$toolTip}
                            {formcheckbox id='openGraphEnabled' group='config'}
                            <span class="z-formnote">{gt text='Add Open Graph meta data to your site\'s <code>&lt;head&gt;</code> section. You can specify some of the ID\'s that are sometimes needed below:'}</span>
                        </div>
                        <div class="z-formrow">
                            {gt text='App to use as Facebook admin' assign='toolTip'}
                            {formlabel for='facebookAdminApp' __text='Facebook admin app' cssClass='museo-form-tooltips ' title=$toolTip}
                            {formintinput id='facebookAdminApp' group='config' maxLength=255 __title='Enter the facebook admin app. Only digits are allowed.'}
                            <span class="z-formnote">{$toolTip}</span>
                        </div>
                        <div class="z-formrow">
                            {gt text='Facebook page url' assign='toolTip'}
                            {formlabel for='facebookSite' __text='Facebook site' cssClass='museo-form-tooltips ' title=$toolTip}
                            {formurlinput id='facebookSite' group='config' maxLength=255 __title='Enter the facebook site.'}
                            <span class="z-formnote">{$toolTip}</span>
                        </div>
                    {if $modvars.ZConfig.startpage eq ''}
                        <h4 class="z-formnote">{gt text="Frontpage settings"}</h4>
                        <p class="z-formnote z-confirmationmsg">{gt text='These are the title, description and image used in the Open Graph meta tags on the front page of your site.'}</p>
                        <div class="z-formrow">
                            {gt text='Open Graph frontpage title' assign='toolTip'}
                            {formlabel for='openGraphFrontpageTitle' __text='Open graph frontpage title' cssClass='museo-form-tooltips ' title=$toolTip}
                            {formtextinput id='openGraphFrontpageTitle' group='config' maxLength=255 __title='Enter the open graph frontpage title.'}
                        </div>
                        <div class="z-formrow">
                            {gt text='Open Graph frontpage description' assign='toolTip'}
                            {formlabel for='openGraphFrontpageDescription' __text='Open graph frontpage description' cssClass='museo-form-tooltips ' title=$toolTip}
                            {formtextinput id='openGraphFrontpageDescription' group='config' maxLength=255 __title='Enter the open graph frontpage description.'}
                        </div>
                        <div class="z-formrow">
                            {gt text='Open Graph frontpage image' assign='toolTip'}
                            {formlabel for='openGraphFrontpageImage' __text='Open graph frontpage image' cssClass='museo-form-tooltips ' title=$toolTip}
                            {formurlinput id='openGraphFrontpageImage' group='config' maxLength=255 __title='Enter the open graph frontpage image.'}
                        </div>
                        <div class="z-formrow">
                            {gt text='OpenGraph default image url' assign='toolTip'}
                            {formlabel for='openGraphDefaultImage' __text='Open graph default image' cssClass='museo-form-tooltips ' title=$toolTip}
                            {formurlinput id='openGraphDefaultImage' group='config' maxLength=255 __title='Enter the open graph default image.'}
                            <span class="z-formnote">{gt text='This image is used if the post/page being shared does not contain any images.'}</span>
                        </div>
                    {/if}
                    </fieldset>
                    <fieldset>
                        <legend>{gt text="Twitter"}</legend>
                        
                        <p class="z-confirmationmsg">{gt text='Note that for the Twitter Cards to work, you have to check the box below and then validate your Twitter Cards through the <a target="_blank" href="https://dev.twitter.com/docs/cards/validation/validator">Twitter Card Validator</a>.'|nl2br}</p>
                        
                        <div class="z-formrow">
                            {gt text='Add Twitter card meta data' assign='toolTip'}
                            {formlabel for='twitterEnabled' __text='Twitter enabled' cssClass='museo-form-tooltips ' title=$toolTip}
                            {formcheckbox id='twitterEnabled' group='config'}
                            <span class="z-formnote">{gt text='Add Twitter card meta data to your site\'s <code>&lt;head&gt;</code> section.'}</span>
                        </div>
                        <div class="z-formrow">
                            {gt text='Site Twitter username' assign='toolTip'}
                            {formlabel for='twitterSiteUser' __text='Twitter site user' cssClass='museo-form-tooltips ' title=$toolTip}
                            {formtextinput id='twitterSiteUser' group='config' maxLength=255 __title='Enter the twitter site user.'}
                            <span class="z-formnote">{$toolTip}</span>
                        </div>
                        <div class="z-formrow">
                            {gt text='The default card type to use' assign='toolTip'}
                            {formlabel for='twitterDefaultCardType' __text='Twitter default card type' cssClass='museo-form-tooltips ' title=$toolTip}
                            {formtextinput id='twitterDefaultCardType' group='config' maxLength=255 __title='Enter the twitter default card type.'}
                            <span class="z-formnote">{$toolTip}</span>
                        </div>
                    </fieldset>
                    <fieldset>
                        <legend>{gt text="Google+"}</legend>
                        <div class="z-formrow">
                            {gt text='Add Google+ specific post meta data' assign='toolTip'}
                            {formlabel for='googlePlusEnabled' __text='Google plus enabled' cssClass='museo-form-tooltips ' title=$toolTip}
                            {formcheckbox id='googlePlusEnabled' group='config'}
                            <span class="z-formnote">{$toolTip}</span>
                        </div>
                        <div class="z-formrow">
                            {gt text='Google publisher page' assign='toolTip'}
                            {formlabel for='googlePlusPublisherPage' __text='Google plus publisher page' cssClass='museo-form-tooltips ' title=$toolTip}
                            {formtextinput id='googlePlusPublisherPage' group='config' maxLength=255 __title='Enter the google plus publisher page.'}
                            <span class="z-formnote">{gt text='If you have a Google+ page for your business, add that URL here and link it on your Google+ page\'s about page.'}</span>
                        </div>
                    </fieldset>
                {/formtabbedpanel}
            {/formtabbedpanelset}

            <div class="z-buttons z-formbuttons">
                {formbutton commandName='save' __text='Update configuration' class='z-bt-save'}
                {formbutton commandName='cancel' __text='Cancel' class='z-bt-cancel'}
            </div>
        {/museoFormFrame}
    {/form}
</div>
{include file='admin/footer.tpl'}
<script type="text/javascript">
/* <![CDATA[ */
    document.observe('dom:loaded', function() {
        Zikula.UI.Tooltips($$('.museo-form-tooltips'));
    });
/* ]]> */
</script>
