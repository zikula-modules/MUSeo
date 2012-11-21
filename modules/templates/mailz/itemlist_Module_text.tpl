{* Purpose of this template: Display modules in text mailings *}
{foreach item='item' from=$items}
        {$item.name}
        {modurl modname='MUSeo' type='user' func='display' ot=$objectType id=$item.id fqurl=true}
-----
{foreachelse}
    {gt text='No modules found.'}
{/foreach}
