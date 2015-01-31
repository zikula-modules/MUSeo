{* purpose of this template: build the Form to edit an instance of extension *}
{assign var='lct' value='user'}
{if isset($smarty.get.lct) && $smarty.get.lct eq 'admin'}
    {assign var='lct' value='admin'}
{/if}
{include file="`$lct`/header.tpl"}
{pageaddvar name='javascript' value='modules/MUSeo/javascript/MUSeo_editFunctions.js'}
{pageaddvar name='javascript' value='modules/MUSeo/javascript/MUSeo_validation.js'}

{if $mode eq 'edit'}
    {gt text='Edit extension' assign='templateTitle'}
    {if $lct eq 'admin'}
        {assign var='adminPageIcon' value='edit'}
    {/if}
{elseif $mode eq 'create'}
    {gt text='Create extension' assign='templateTitle'}
    {if $lct eq 'admin'}
        {assign var='adminPageIcon' value='new'}
    {/if}
{else}
    {gt text='Edit extension' assign='templateTitle'}
    {if $lct eq 'admin'}
        {assign var='adminPageIcon' value='edit'}
    {/if}
{/if}
<div class="museo-extension museo-edit">
    {pagesetvar name='title' value=$templateTitle}
    {if $lct eq 'admin'}
        <div class="z-admin-content-pagetitle">
            {icon type=$adminPageIcon size='small' alt=$templateTitle}
            <h3>{$templateTitle}</h3>
        </div>
    {else}
        <h2>{$templateTitle}</h2>
    {/if}
{form cssClass='z-form'}
    {* add validation summary and a <div> element for styling the form *}
    {museoFormFrame}
    {formsetinitialfocus inputId='name'}

    <fieldset>
        <legend>{gt text='Content'}</legend>
        
        <div class="z-formrow">
            {formlabel for='name' __text='Name' mandatorysym='1' cssClass=''}
            {formtextinput group='extension' id='name' mandatory=true readOnly=false __title='Enter the name of the extension' textMode='singleline' maxLength=255 cssClass='required validate-unique' }
            {museoValidationError id='name' class='required'}
            {museoValidationError id='name' class='validate-unique'}
            <span class="z-formnote">{gt text="Enter the name of the extension"}</span>
        </div>
        
        <div class="z-formrow">
            {gt text='Enter the controller for the view of objects; for example view.' assign='toolTip'}
            {formlabel for='controllerForView' __text='Controller for view' cssClass='museo-form-tooltips' title=$toolTip}
            {formtextinput group='extension' id='controllerForView' mandatory=false readOnly=false __title='Enter the controller for view of the extension' textMode='singleline' maxLength=50 cssClass='' }
            <span class="z-formnote">{$toolTip}</span>
        </div>
        
        <div class="z-formrow">
            {gt text='Select the controller for single entity of this module.' assign='toolTip'}
            {formlabel for='controllerForSingleObject' __text='Controller for single object' mandatorysym='1' cssClass='museo-form-tooltips' title=$toolTip}
            {formtextinput group='extension' id='controllerForSingleObject' mandatory=true readOnly=false __title='Enter the controller for single object of the extension' textMode='singleline' maxLength=50 cssClass='required' }
            {museoValidationError id='controllerForSingleObject' class='required'}
            <span class="z-formnote">{$toolTip}</span>
        </div>
        
        <div class="z-formrow">
            {gt text='Enter the paremeter for objects; for example ot.' assign='toolTip'}
            {formlabel for='parameterForObjects' __text='Parameter for objects' cssClass='museo-form-tooltips' title=$toolTip}
            {formtextinput group='extension' id='parameterForObjects' mandatory=false readOnly=false __title='Enter the parameter for objects of the extension' textMode='singleline' maxLength=50 cssClass='' }
            <span class="z-formnote">{$toolTip}</span>
        </div>
        
        <div class="z-formrow">
            {gt text='Enter the name of the identifier for this module; for example id.' assign='toolTip'}
            {formlabel for='nameOfIdentifier' __text='Name of identifier' mandatorysym='1' cssClass='museo-form-tooltips' title=$toolTip}
            {formtextinput group='extension' id='nameOfIdentifier' mandatory=true readOnly=false __title='Enter the name of identifier of the extension' textMode='singleline' maxLength=255 cssClass='required' }
            {museoValidationError id='nameOfIdentifier' class='required'}
            <span class="z-formnote">{$toolTip}</span>
        </div>
        
        <div class="z-formrow">
            {gt text='Enter other additional identifiers comma separated.' assign='toolTip'}
            {formlabel for='extraIdentifier' __text='Extra identifier' cssClass='museo-form-tooltips' title=$toolTip}
            {formtextinput group='extension' id='extraIdentifier' mandatory=false readOnly=false __title='Enter the extra identifier of the extension' textMode='singleline' maxLength=255 cssClass='' }
            <span class="z-formnote">{$toolTip}</span>
        </div>
    </fieldset>
    
    {if $mode ne 'create'}
        {include file='helper/include_standardfields_edit.tpl' obj=$extension}
    {/if}
    
    {* include display hooks *}
    {if $mode ne 'create'}
        {assign var='hookId' value=$extension.id}
        {notifydisplayhooks eventname='museo.ui_hooks.extensions.form_edit' id=$hookId assign='hooks'}
    {else}
        {notifydisplayhooks eventname='museo.ui_hooks.extensions.form_edit' id=null assign='hooks'}
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
                    {formcheckbox group='extension' id='repeatCreation' readOnly=false}
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
            {gt text='Really delete this extension?' assign='deleteConfirmMsg'}
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
    
        mUMUSeoAddCommonValidationRules('extension', '{{if $mode ne 'create'}}{{$extension.id}}{{/if}}');
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
    });
/* ]]> */
</script>
