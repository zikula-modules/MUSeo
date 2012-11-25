{* purpose of this template: modules display view in admin area *}
{include file='admin/header.tpl'}
<div class="museo-module museo-display">
{gt text='Module' assign='templateTitle'}
{assign var='templateTitle' value=$module.name|default:$templateTitle}
{pagesetvar name='title' value=$templateTitle|@html_entity_decode}
<div class="z-admin-content-pagetitle">
    {icon type='display' size='small' __alt='Details'}
    <h3>{$templateTitle|notifyfilters:'museo.filter_hooks.modules.filter'}</h3>
</div>


<dl id="MUSeo_body">
    <dt>{gt text='Controller for view'}</dt>
    <dd>{$module.controllerForView}</dd>
    <dt>{gt text='Controller for single object'}</dt>
    <dd>{$module.controllerForSingleObject}</dd>
    <dt>{gt text='Parameter for objects'}</dt>
    <dd>{$module.parameterForObjects}</dd>
    <dt>{gt text='Name of identifier'}</dt>
    <dd>{$module.nameOfIdentifier}</dd>
    <dt>{gt text='Extra identifier'}</dt>
    <dd>{$module.extraIdentifier}</dd>
</dl>
    {include file='admin/include_standardfields_display.tpl' obj=$module}

{if !isset($smarty.get.theme) || $smarty.get.theme ne 'Printer'}
{if count($module._actions) gt 0}
    <p>{strip}
    {foreach item='option' from=$module._actions}
        <a href="{$option.url.type|museoActionUrl:$option.url.func:$option.url.arguments}" title="{$option.linkTitle|safetext}" class="z-icon-es-{$option.icon}">
            {$option.linkText|safetext}
        </a>
    {/foreach}
    {/strip}</p>
{/if}

{* include display hooks *}
{notifydisplayhooks eventname='museo.ui_hooks.modules.display_view' id=$module.id urlobject=$currentUrlObject assign='hooks'}
{foreach key='hookname' item='hook' from=$hooks}
    {$hook}
{/foreach}

{/if}

</div>
{include file='admin/footer.tpl'}

