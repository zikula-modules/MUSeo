'use strict';


/**
 * Resets the value of an upload / file input field.
 */
function mUMUSeoResetUploadField(fieldName)
{
    if ($(fieldName) != null) {
        $(fieldName).setAttribute('type', 'input');
        $(fieldName).setAttribute('type', 'file');
    }
}

/**
 * Initialises the reset button for a certain upload input.
 */
function mUMUSeoInitUploadField(fieldName)
{
    var fieldNameCapitalised;

    fieldNameCapitalised = fieldName.charAt(0).toUpperCase() + fieldName.substring(1);
    if ($('reset' + fieldNameCapitalised + 'Val') != null) {
        $('reset' + fieldNameCapitalised + 'Val').observe('click', function (evt) {
            evt.preventDefault();
            mUMUSeoResetUploadField(fieldName);
        }).removeClassName('z-hide').setStyle({ display: 'block' });
    }
}

