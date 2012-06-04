document.observe('dom:loaded', function () {
    var i = 1;
    while ($$('[name="calculation[' + i + ']"]').first()) {
        if (!($$('[name="calculation[' + i + ']"]').first().checked)) {
            $('repeat_block_' + i).hide();
        }
        i++;
    }

    i = 1;

    while ($$('[name="attachment_info[' + i + ']"]').first()) {
        if (!($$('[name="attachment_info[' + i + ']"]').first().checked)) {
            $('attachment_info_' + i).hide();
        }
        i++;
    }
});

function addAttachmentInfo(sender) {
    var name_array = sender.name.split(/[\[\]]/);
    var name_id = name_array[1];

    if (sender.checked) {
        $("attachment_info_" + name_id).show();
    } else {
        $('attachment_info_' + name_id).hide();
    }
}
function calculatePrice(sender) {
    var name_array = sender.name.split(/[\[\]]/);
    var name_id = name_array[1];
    var name_field = name_array[5] || name_array[3];
    var repeat_id_field = ((name_array[3] == 'rate') || (name_array[3] == 'volume')) ? null : name_array[3];

    var price_value = 0;
    var rate_value = 0;
    var volume_value = 0;


    if (name_field == 'rate') {
        if (repeat_id_field == null)
            volume_value = $$('[name="attachments[' + name_id + '][volume]"]').first().value;
        else
            volume_value = $$('[name="attachments[' + name_id + '][' + repeat_id_field + '][volume]"]').first().value;

        rate_value = sender.value;

        if (volume_value == "") {
            volume_value = 0;
        }

        if (rate_value == "") {
            rate_value = 0;
        }
    }


    if (name_field == 'volume') {
        volume_value = sender.value;
        if (repeat_id_field == null)
            rate_value = $$('[name="attachments[' + name_id + '][rate]"]').first().value;
        else
            rate_value = $$('[name="attachments[' + name_id + '][' + repeat_id_field + '][rate]"]').first().value;

        if (volume_value == "") {
            volume_value = 0;
        }

        if (rate_value == "") {
            rate_value = 0;

        }
    }

    price_value = rate_value * volume_value;

    if (repeat_id_field == null)
        $$('[name="attachments[' + name_id + '][price]"]').first().value = price_value || '';
    else {
        $$('[name="attachments[' + name_id + '][' + repeat_id_field + '][price]"]').first().value = price_value || '';
        updateSimple(name_id);
    }

    calculateGeneralPrice(name_id);
}

function calculateLayoutPrice(sender) {
    var name_array = sender.name.split(/[\[\]]/);
    var name_id = name_array[1];
    var name_field = name_array[5];

    var price_value = 0;
    var rate_value = 0;
    var volume_value = 0;

    if (name_field == 'rate') {
        volume_value = $$('[name="attachments[' + name_id + '][layout][volume]"]').first().value;
        rate_value = sender.value;

        if (volume_value == "") {
            volume_value = 0;
        }

        if (rate_value == "") {
            rate_value = 0;
        }
    }


    if (name_field == 'volume') {
        volume_value = sender.value;
        rate_value = $$('[name="attachments[' + name_id + '][layout][rate]"]').first().value || '';

        if (volume_value == "") {
            volume_value = 0;
        }

        if (rate_value == "") {
            rate_value = 0;

        }
    }

    price_value = rate_value * volume_value;

    $$('[name="attachments[' + name_id + '][layout][price]"]').first().value = price_value;
    calculateGeneralPrice(name_id);
}

function updateSimple(id) {
    var price = 0, rate = 0, volume = 0;
    var rate_count = 4;
    for (var repeat_id_field = 1; repeat_id_field < 5; repeat_id_field++) {
        t_rate = parseFloat($$('[name="attachments[' + id + '][' + repeat_id_field + '][rate]"]').first().value)
        t_volume = parseFloat($$('[name="attachments[' + id + '][' + repeat_id_field + '][volume]"]').first().value)

        rate += t_rate || 0;
        volume += t_volume || 0;

        if (!t_rate) rate_count--;
    }

    $$('[name="attachments[' + id + '][volume]"]').first().value = volume;
    $$('[name="attachments[' + id + '][rate]"]').first().value = rate / rate_count;
    $$('[name="attachments[' + id + '][price]"]').first().value = volume * (rate / rate_count);
}

function addFileField() {
    var fields = $('attachments_fields');
    if (fields.childElements().length >= 10) return false;
    fileFieldCount = fields.childElements().length + 1
    var s = document.createElement("span");
    s.update(fields.down('span', (fileFieldCount - 2) * 3 ).innerHTML);
    s.down('input.file').name = "attachments[" + fileFieldCount + "][file]";
    s.down('input.file').value = "";
    s.down('input.description').name = "attachments[" + fileFieldCount + "][description]";
    s.down('input.description').value = "";
    s.down('input.volume').name = "attachments[" + fileFieldCount + "][volume]";
    s.down('input.volume').value = "";
    s.down('input.volume').disabled = "";
    s.down('input.rate').name = "attachments[" + fileFieldCount + "][rate]";
    s.down('input.rate').value = "";
    s.down('input.rate').disabled = "";
    s.down('input.price').name = "attachments[" + fileFieldCount + "][price]";
    s.down('input.price').value = "";
    s.down('input.price').disabled = "disabled";

    s.down('#repeat_block_' + (fileFieldCount - 1)).id = 'repeat_block_' + fileFieldCount;
    s.down('#attachment_info_' + (fileFieldCount - 1)).id = 'attachment_info_' + fileFieldCount;
    s.down('input.attachment_info').name = "attachment_info[" + fileFieldCount + "]";
    s.down('input.attachment_info').value = "";
    s.down('input.attachment_info').checked = false;
    s.down('input.calculation').name = "calculation[" + fileFieldCount + "]";
    s.down('input.calculation').value = "";
    s.down('input.calculation').checked = false;

    s.down('input.layout_volume').name = "attachments[" + fileFieldCount + "][layout][volume]";
    s.down('input.layout_volume').value = "";
    s.down('input.layout_rate').name = "attachments[" + fileFieldCount + "][layout][rate]";
    s.down('input.layout_rate').value = "";
    s.down('input.layout_price').name = "attachments[" + fileFieldCount + "][layout][price]";
    s.down('input.layout_price').value = "";

    s.down('input.general_price').name = "attachments[" + fileFieldCount + "][general][price]";
    s.down('input.general_price').value = "";

    var i = 0;
    while (i < 4) {
        i++;
        s.down('input.volume', i).name = "attachments[" + fileFieldCount + "][" + i + "][volume]";
        s.down('input.volume', i).value = "";
        s.down('input.rate', i).name = "attachments[" + fileFieldCount + "][" + i + "][rate]";
        s.down('input.rate', i).value = "";
        s.down('input.price', i).name = "attachments[" + fileFieldCount + "][" + i + "][price]";
        s.down('input.price', i).value = "";
    }
    fields.appendChild(s);
    s.down('#repeat_block_' + fileFieldCount).hide();
    s.down('#attachment_info_' + fileFieldCount).hide();
//    fields.appendChild(document.createElement("br"));
}

function chooseCalculationSimple(sender) {
    var name_array = sender.name.split(/[\[\]]/);
    var name_id = name_array[1];

    for (var repeat_id_field = 1; repeat_id_field < 5; repeat_id_field++) {
        $$('[name="attachments[' + name_id + '][' + repeat_id_field + '][price]"]').first().disabled = 'disabled';
        $$('[name="attachments[' + name_id + '][' + repeat_id_field + '][rate]"]').first().disabled = 'disabled';
        $$('[name="attachments[' + name_id + '][' + repeat_id_field + '][volume]"]').first().disabled = 'disabled';
    }

    $$('[name="attachments[' + name_id + '][price]"]').first().disabled = '';
    $$('[name="attachments[' + name_id + '][rate]"]').first().disabled = '';
    $$('[name="attachments[' + name_id + '][volume]"]').first().disabled = '';
}

function chooseCalculationRepeat(sender) {
    var name_array = sender.name.split(/[\[\]]/);
    var name_id = name_array[1];

    var simple_rate = $$('[name="attachments[' + name_id + '][rate]"]').first();
    var simple_volume = $$('[name="attachments[' + name_id + '][volume]"]').first();

    if (sender.checked) {
        $('repeat_block_' + name_id).show();

        simple_rate.disabled = 'disabled';
        simple_volume.disabled = 'disabled';
    } else {
        $('repeat_block_' + name_id).hide();

        simple_rate.disabled = '';
        simple_volume.disabled = '';
    }
}

function calculateGeneralPrice(id) {
    price = parseFloat($$('[name="attachments[' + id + '][price]"]').first().value) || 0
    layout_price = parseFloat($$('[name="attachments[' + id + '][layout][price]"]').first().value) || 0

    general_price = price + layout_price

    $$('[name="attachments[' + id + '][general][price]"]').first().value = general_price || ''
}
