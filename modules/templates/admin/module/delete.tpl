{* purpose of this template: modules delete confirmation view in admin area *}
{include file='admin/header.tpl'}
<div class="museo-module museo-delete">
{gt text='Delete module' assign='templateTitle'}
{pagesetvar name='title' value=$templateTitle}
<div class="z-admin-content-pagetitle">
    {icon type='delete' size='small' __alt='Delete'}
    <h3>{$templateTitle}</h3>
</div>

    <p class="z-warningmsg">{gt text='Do you really want to delete this module ?'}</p>

    <form class="z-form" action="{modurl modname='MUSeo' type='admin' func='delete' ot='module' id=$module.id}" method="post">
        <div>
            <input type="hidden" name="csrftoken" value="{insert name='csrftoken'}" />
            <input type="hidden" id="confirmation" name="confirmation" value="1" />
            <fieldset>
                <legend>{gt text='Confirmation prompt'}</legend>
                <div class="z-buttons z-formbuttons">
                    {gt text='Delete' assign='deleteTitle'}
                    {button src='14_layer_deletelayer.png' set='icons/small' text=$deleteTitle title=$deleteTitle class='z-btred'}
                    <a href="{modurl modname='MUSeo' type='admin' func='view' ot='module'}">{icon type='cancel' size='small' __alt='Cancel' __title='Cancel'} {gt text='Cancel'}</a>
                </div>
            </fieldset>

            {notifydisplayhooks eventname='museo.ui_hooks.modules.form_delete' id="`$module.id`" assign='hooks'}
            {foreach from=$hooks key='hookName' item='hook'}
            <fieldset>
                <legend>{$hookName}</legend>
                {$hook}
            </fieldset>
            {/foreach}
        </div>
    </form>
</div>
{include file='admin/footer.tpl'}
