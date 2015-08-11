var api = $.api = {
    $calculation: $('tbody#calculation'),

    $form: $('form#calculator-form'),

    utils: {
        removeErrorsFrom: function($element) {
            $element.find('.has-error').removeClass('has-error');
            $element.find('span.help-block').remove();
        }
    },

    callbacks: {
        // Actual form submit
        submit: function(event) {
            event.preventDefault(); // Don't submit form right away

            $this = $(this);

            $.ajax({
                url:  $this.attr('action'),
                method: $this.attr('method'),
                data: $this.serialize(),
                dataType: 'json'
            }).done(api.callbacks.submitSuccess).fail(api.callbacks.submitError);
        },

        submitSuccess: function(data) {
            api.$calculation.html(data.calculation);
        },

        submitError: function(data) {
            var errors = data.responseJSON.errors;

            $.each(errors, function(attribute, attributeErrors) {
                if ( errors.length == 0 ) return false;

                var $input          = $('#' + attribute);
                var $inputFormGroup = $input.parents('div.form-group');

                $inputFormGroup.addClass('has-error');

                $.each(attributeErrors, function(_, error) {
                    $input.after("<span class='help-block'>" + error + "</span>");
                });
                // console.log(attribute);
                // console.log(errors);
            });
        }
    }
};


// Events
api.$form.bind('submit', api.callbacks.submit)
