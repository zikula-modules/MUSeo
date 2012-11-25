{* purpose of this template: build the Form to edit an instance of module *}
{include file='admin/header.tpl'}
{pageaddvar name='javascript' value='modules/MUSeo/javascript/MUSeo_editFunctions.js'}
{pageaddvar name='javascript' value='modules/MUSeo/javascript/MUSeo_validation.js'}

{if $mode eq 'edit'}
    {gt text='Edit module' assign='templateTitle'}
    {assign var='adminPageIcon' value='edit'}
{elseif $mode eq 'create'}
    {gt text='Create module' assign='templateTitle'}
    {assign var='adminPageIcon' value='new'}
{else}
    {gt text='Edit module' assign='templateTitle'}
    {assign var='adminPageIcon' value='edit'}
{/if}
<div class="museo-module museo-edit">
{pagesetvar name='title' value=$templateTitle}
<div class="z-admin-content-pagetitle">
    {icon type=$adminPageIcon size='small' alt=$templateTitle}
    <h3>{$templateTitle}</h3>
</div>
{form cssClass='z-form'}
    {* add validation summary and a <div> element for styling the form *}
    {museoFormFrame}
    {formsetinitialfocus inputId='name'}

    <fieldset>
        <legend>{gt text='Content'}</legend>
        <div class="z-formrow">
            {formlabel for='name' __text='Name' mandatorysym='1'}
            {formdropdownlist group='module' id='name' mandatory=true readOnly=false __title='Enter the name of the module' textMode='singleline' maxLength=255 cssClass='required validate-unique'}
            {museoValidationError id='name' class='required'}
            {museoValidationError id='name' class='validate-unique'}
        </div>
        <div class="z-formrow">
            {gt text='Enter the controller for the view of objects; for example "view".' assign='toolTip'}
            {formlabel for='controllerForView' __text='Controller for view' class='museoFormTooltips' title=$toolTip}
            {formtextinput group='module' id='controllerForView' mandatory=false readOnly=false __title='Enter the controller for view of the module' textMode='singleline' maxLength=50 cssClass=''}
        </div>
        <div class="z-formrow">
            {gt text='Select the controller for single entity of this module!' assign='toolTip'}
            {formlabel for='controllerForSingleObject' __text='Controller for single object' mandatorysym='1' class='museoFormTooltips' title=$toolTip}
            {formtextinput group='module' id='controllerForSingleObject' mandatory=true readOnly=false __title='Enter the controller for single object of the module' textMode='singleline' maxLength=50 cssClass='required'}
            {museoValidationError id='controllerForSingleObject' class='required'}
        </div>
        <div class="z-formrow">
            {gt text='Enter the paremeter for objects; for example "ot! If you not enter the parameter "id" will be taken!' assign='toolTip'}
            {formlabel for='parameterForObjects' __text='Parameter for objects' class='museoFormTooltips' title=$toolTip}
            {formtextinput group='module' id='parameterForObjects' mandatory=false readOnly=false __title='Enter the parameter for objects of the module' textMode='singleline' maxLength=50 cssClass=''}
        </div>
        <div class="z-formrow">
            {gt text='Enter the name of the identifier for this module; for example "id"!' assign='toolTip'}
            {formlabel for='nameOfIdentifier' __text='Name of identifier' class='museoFormTooltips' title=$toolTip}
            {formtextinput group='module' id='nameOfIdentifier' mandatory=false readOnly=false __title='Enter the name of identifier of the module' textMode='singleline' maxLength=255 cssClass=''}
        </div>
      {*  <div class="z-formrow">
            {gt text='Enter other additional identifiers comma seperated!' assign='toolTip'}
            {formlabel for='extraIdentifier' __text='Extra identifier' class='museoFormTooltips' title=$toolTip}
            {formtextinput group='module' id='extraIdentifier' mandatory=false readOnly=false __title='Enter the extra identifier of the module' textMode='singleline' maxLength=255 cssClass=''}
        </div> *}
    </fieldset>

    {if $mode ne 'create'}
        {include file='admin/include_standardfields_edit.tpl' obj=$module}
    {/if}

    {* include display hooks *}
    {if $mode eq 'create'}
        {notifydisplayhooks eventname='museo.ui_hooks.modules.form_edit' id=null assign='hooks'}
    {else}
        {notifydisplayhooks eventname='museo.ui_hooks.modules.form_edit' id=$module.id assign='hooks'}
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
                {formcheckbox group='module' id='repeatcreation' readOnly=false}
            </div>
        </fieldset>
    {/if}

    {* include possible submit actions *}
    <div class="z-buttons z-formbuttons">
    {if $mode eq 'edit'}
        {formbutton id='btnUpdate' commandName='update' __text='Update module' class='z-bt-save'}
      {if !$inlineUsage}
        {gt text='Really delete this module?' assign='deleteConfirmMsg'}
        {formbutton id='btnDelete' commandName='delete' __text='Delete module' class='z-bt-delete z-btred' confirmMessage=$deleteConfirmMsg}
      {/if}
    {elseif $mode eq 'create'}
        {formbutton id='btnCreate' commandName='create' __text='Create module' class='z-bt-ok'}
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

        museoAddCommonValidationRules('module', '{{if $mode eq 'create'}}{{else}}{{$module.id}}{{/if}}');

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
