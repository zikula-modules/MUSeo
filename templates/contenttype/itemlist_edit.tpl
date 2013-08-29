{* Purpose of this template: edit view of generic item list content type *}

<div class="z-formrow">
    {formlabel for='MUSeo_objecttype' __text='Object type'}
    {museoSelectorObjectTypes assign='allObjectTypes'}
    {formdropdownlist id='MUSeo_objecttype' dataField='objectType' group='data' mandatory=true items=$allObjectTypes}
</div>

<div class="z-formrow">
    {formlabel __text='Sorting'}
    <div>
        {formradiobutton id='MUSeo_srandom' value='random' dataField='sorting' group='data' mandatory=true}
        {formlabel for='MUSeo_srandom' __text='Random'}
        {formradiobutton id='MUSeo_snewest' value='newest' dataField='sorting' group='data' mandatory=true}
        {formlabel for='MUSeo_snewest' __text='Newest'}
        {formradiobutton id='MUSeo_sdefault' value='default' dataField='sorting' group='data' mandatory=true}
        {formlabel for='MUSeo_sdefault' __text='Default'}
    </div>
</div>

<div class="z-formrow">
    {formlabel for='MUSeo_amount' __text='Amount'}
    {formtextinput id='MUSeo_amount' dataField='amount' group='data' mandatory=true maxLength=2}
</div>

<div class="z-formrow">
    {formlabel for='MUSeo_template' __text='Template File'}
    {museoSelectorTemplates assign='allTemplates'}
    {formdropdownlist id='MUSeo_template' dataField='template' group='data' mandatory=true items=$allTemplates}
</div>

<div class="z-formrow">
    {formlabel for='MUSeo_filter' __text='Filter (expert option)'}
    {formtextinput id='MUSeo_filter' dataField='filter' group='data' mandatory=false maxLength=255}
    <div class="z-formnote">({gt text='Syntax examples'}: <kbd>name:like:foobar</kbd> {gt text='or'} <kbd>status:ne:3</kbd>)</div>
</div>
