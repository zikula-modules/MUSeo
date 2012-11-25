{* purpose of this template: build the Form to edit an instance of metatag *}
{include file='admin/header.tpl'}
{pageaddvar name='javascript' value='modules/MUSeo/javascript/MUSeo_editFunctions.js'}
{pageaddvar name='javascript' value='modules/MUSeo/javascript/MUSeo_validation.js'}

{if $mode eq 'edit'}
    {gt text='Edit metatag' assign='templateTitle'}
    {assign var='adminPageIcon' value='edit'}
{elseif $mode eq 'create'}
    {gt text='Create metatag' assign='templateTitle'}
    {assign var='adminPageIcon' value='new'}
{else}
    {gt text='Edit metatag' assign='templateTitle'}
    {assign var='adminPageIcon' value='edit'}
{/if}
<div class="museo-metatag museo-edit">
{pagesetvar name='title' value=$templateTitle}
<div class="z-admin-content-pagetitle">
    {icon type=$adminPageIcon size='small' alt=$templateTitle}
    <h3>{$templateTitle}</h3>
</div>
{form cssClass='z-form'}
    {* add validation summary and a <div> element for styling the form *}
    {museoFormFrame}
    {formsetinitialfocus inputId='titleOfEntity'}

    <fieldset>
        <legend>{gt text='Content'}</legend>
        <div class="z-formrow">
            {gt text='Enter the title of this entity; so you can find it!' assign='toolTip'}
            {formlabel for='titleOfEntity' __text='Title of entity' mandatorysym='1' class='museoFormTooltips' title=$toolTip}
            {formtextinput group='metatag' id='titleOfEntity' mandatory=true readOnly=false __title='Enter the title of entity of the metatag' textMode='singleline' maxLength=255 cssClass='required'}
            {museoValidationError id='titleOfEntity' class='required'}
        </div>
        <div class="z-formrow">
            {gt text='Enter the title, that has to be set as title in html!' assign='toolTip'}
            {formlabel for='title' __text='Title' class='museoFormTooltips' title=$toolTip}
            {formtextinput group='metatag' id='title' mandatory=false readOnly=false __title='Enter the title of the metatag' textMode='singleline' maxLength=255 cssClass=''}
        </div>
        <div class="z-formrow">
            {gt text='Enter the description, that has to be set as description in html!' assign='toolTip'}
            {formlabel for='description' __text='Description' class='museoFormTooltips' title=$toolTip}
            {formtextinput group='metatag' id='description' mandatory=false readOnly=false __title='Enter the description of the metatag' textMode='singleline' maxLength=255 cssClass=''}
        </div>
        <div class="z-formrow">
            {gt text='Enter the keywords; comma seperated - for example: Zikula, Framework.' assign='toolTip'}
            {formlabel for='keywords' __text='Keywords' class='museoFormTooltips' title=$toolTip}
            {formtextinput group='metatag' id='keywords' mandatory=false readOnly=false __title='Enter the keywords of the metatag' textMode='singleline' maxLength=255 cssClass=''}
        </div>
        <div class="z-formrow">
            {gt text='Select the module!' assign='toolTip'}
            {formlabel for='theModule' __text='The module' mandatorysym='1' class='museoFormTooltips' title=$toolTip}
            {formdropdownlist group='metatag' id='theModule' mandatory=true readOnly=false __title='Enter the the module of the metatag' textMode='singleline' maxLength=50 cssClass='required'}
            {museoValidationError id='theModule' class='required'}
        </div>
        <div class="z-formrow">
            {gt text='Enter the function of your selected module!' assign='toolTip'}
            {formlabel for='functionOfModule' __text='Function of module' mandatorysym='1' class='museoFormTooltips' title=$toolTip}
            {formtextinput group='metatag' id='functionOfModule' mandatory=true readOnly=false __title='Enter the function of module of the metatag' textMode='singleline' maxLength=50 cssClass='required'}
            {museoValidationError id='functionOfModule' class='required'}
        </div>
        <div class="z-formrow">
            {gt text='Enter the object of your selected module!' assign='toolTip'}
            {formlabel for='objectOfModule' __text='Object of module' class='museoFormTooltips' title=$toolTip}
            {formtextinput group='metatag' id='objectOfModule' mandatory=false readOnly=false __title='Enter the object of module of the metatag' textMode='singleline' maxLength=50 cssClass=''}
        </div>
        <div class="z-formrow">
            {gt text='Enter the name for the single identifier! For example id!' assign='toolTip'}
            {formlabel for='nameOfIdentifier' __text='Name of identifier' class='museoFormTooltips' title=$toolTip}
            {formtextinput group='metatag' id='nameOfIdentifier' mandatory=false readOnly=false __title='Enter the name of identifier of the metatag' textMode='singleline' maxLength=20 cssClass=''}
        </div>
        <div class="z-formrow">
            {gt text='Enter the id of your selected module; only necessary if you have entered a function that calls a single entity!' assign='toolTip'}
            {formlabel for='idOfObject' __text='Id of object' class='museoFormTooltips' title=$toolTip}
            {formintinput group='metatag' id='idOfObject' mandatory=false __title='Enter the id of object of the metatag' maxLength=11 cssClass=' validate-digits'}
            {museoValidationError id='idOfObject' class='validate-digits'}
        </div>
        <div class="z-formrow">
            {gt text='Entr the the string of an object! For example Zikula!' assign='toolTip'}
            {formlabel for='stringOfObject' __text='String of object' class='museoFormTooltips' title=$toolTip}
            {formtextinput group='metatag' id='stringOfObject' mandatory=false readOnly=false __title='Enter the string of object of the metatag' textMode='singleline' maxLength=50 cssClass=''}
        </div>
      {*  <div class="z-formrow">
            {gt text='Enter other parameters and their values comma seperated like parameter1=value1,parameter2=value2!' assign='toolTip'}
            {formlabel for='extraInfos' __text='Extra infos' class='museoFormTooltips' title=$toolTip}
            {formtextinput group='metatag' id='extraInfos' mandatory=false readOnly=false __title='Enter the extra infos of the metatag' textMode='singleline' maxLength=255 cssClass=''}
        </div> *}
    </fieldset>

    {if $mode ne 'create'}
        {include file='admin/include_standardfields_edit.tpl' obj=$metatag}
    {/if}

    {* include display hooks *}
    {if $mode eq 'create'}
        {notifydisplayhooks eventname='museo.ui_hooks.metatags.form_edit' id=null assign='hooks'}
    {else}
        {notifydisplayhooks eventname='museo.ui_hooks.metatags.form_edit' id=$metatag.id assign='hooks'}
    {/if}
    {if is_array($hooks) && isset($hooks[0])}
        <fieldset>
            <legend>{gt text='Hooks'}</legend>
            {foreach key='hookName' item='hook' from=$hooks}
            <div class="z-formrow">
                {$hook}
            </div>
            {/foreach}
        </fieldset>
    {/if}

    {* include return control *}
    {if $mode eq 'create'}
        <fieldset>
            <legend>{gt text='Return control'}</legend>
            <div class="z-formrow">
                {formlabel for='repeatcreation' __text='Create another item after save'}
                {formcheckbox group='metatag' id='repeatcreation' readOnly=false}
            </div>
        </fieldset>
    {/if}

    {* include possible submit actions *}
    <div class="z-buttons z-formbuttons">
    {if $mode eq 'edit'}
        {formbutton id='btnUpdate' commandName='update' __text='Update metatag' class='z-bt-save'}
      {if !$inlineUsage}
        {gt text='Really delete this metatag?' assign='deleteConfirmMsg'}
        {formbutton id='btnDelete' commandName='delete' __text='Delete metatag' class='z-bt-delete z-btred' confirmMessage=$deleteConfirmMsg}
      {/if}
    {elseif $mode eq 'create'}
        {formbutton id='btnCreate' commandName='create' __text='Create metatag' class='z-bt-ok'}
    {else}
        {formbutton id='btnUpdate' commandName='update' __text='OK' class='z-bt-ok'}
    {/if}
        {formbutton id='btnCancel' commandName='cancel' __text='Cancel' class='z-bt-cancel'}
    </div>
  {/museoFormFrame}
{/form}

</div>
{include file='admin/footer.tpl'}

{icon type='edit' size='extrasmall' assign='editImageArray'}
{icon type='delete' size='extrasmall' assign='deleteImageArray'}

<script type="text/javascript" charset="utf-8">
/* <![CDATA[ */
    var editImage = '<img src="{{$editImageArray.src}}" width="16" height="16" alt="" />';
    var removeImage = '<img src="{{$deleteImageArray.src}}" width="16" height="16" alt="" />';

    document.observe('dom:loaded', function() {

        museoAddCommonValidationRules('metatag', '{{if $mode eq 'create'}}{{else}}{{$metatag.id}}{{/if}}');

        // observe button events instead of form submit
        var valid = new Validation('{{$__formid}}', {onSubmit: false, immediate: true, focusOnError: false});
        {{if $mode ne 'create'}}
            var result = valid.validate();
        {{/if}}

        $('{{if $mode eq 'create'}}btnCreate{{else}}btnUpdate{{/if}}').observe('click', function(event) {
            var result = valid.validate();
            if (!result) {
                // validation error, abort form submit
                Event.stop(event);
            } else {
                // hide form buttons to prevent double submits by accident
                $$('div.z-formbuttons input').each(function(btn) {
                    btn.hide();
                });
            }
            return result;
        });

        Zikula.UI.Tooltips($$('.museoFormTooltips'));
    });

/* ]]> */
</script>
