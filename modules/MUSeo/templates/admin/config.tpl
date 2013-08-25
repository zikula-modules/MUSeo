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

<div class="z-informationmsg z-formnote">{gt text='MUSeo is only working if "compat_layer" is enabled in the config.php.'}</div>
        {* add validation summary and a <div> element for styling the form *}
        {museoFormFrame}
        {formsetinitialfocus inputId='modules'}
            <fieldset>
                <legend>{gt text='Here you can manage all basic settings for this application.'}</legend>

                <div class="z-formrow">
                    {formlabel for='modules' __text='Modules' class='museoFormTooltips' title=$toolTip}
                    {formtextinput id='modules' group='config' maxLength=255 width=20em __title='Enter this setting.'}
                    <div class="z-informationmsg z-formnote">{gt text='Enter the modules you wish to support comma separated without whitespace!'}</div>
                </div>
                <div class="z-formrow">
                    {formlabel for='controllers' __text='Controllers' class='museoFormTooltips' title=$toolTip}
                    {formtextinput id='controllers' group='config' maxLength=255 width=20em __title='Enter this setting.'}
                    <div class="z-informationmsg z-formnote">{gt text='Enter the controller you wish to support comma separated!'}</div>
                </div>
                <div class="z-formrow">
                    {formlabel for='robots' __text='Robots' class='museoFormTooltips' title=$toolTip}
                    {formtextinput id='robots' group='config' maxLength=255 width=20em __title='Enter this setting.'}
                    <div class="z-informationmsg z-formnote">{gt text='Enter the standard text for the robots like index, nofollow! It will be set if there is no metatag set in MUSeo.'}</div>
                </div>
            </fieldset>

            <div class="z-buttons z-formbuttons">
                {formbutton commandName='save' __text='Update configuration' class='z-bt-save'}
                {formbutton commandName='cancel' __text='Cancel' class='z-bt-cancel'}
            </div>
        {/museoFormFrame}
    {/form}
</div>
{include file='admin/footer.tpl'}
