$(document).ready(function () {
    $('#customers').dataTable();
    $('#item_prices').dataTable();

        $('table.display').dataTable();

    $('#open-time').timepicker();
    $('#close-time').timepicker();

    // $('.service-provider-mobile-number').keydown(function(){
    //     console.log($('.service-provider-mobile-number').val())
    //     console.log($('.service-provider-mobile-number').val().length)
    //     if ($('.service-provider-mobile-number').val().length > 1){
    //         return false;
    //     };
    // })
    //
    var max_chars = 10;

    $('.service-provider-mobile-number').keydown( function(e){
        if ($(this).val().length >= max_chars) {
            $(this).val($(this).val().substr(0, max_chars));
        }
    });
    $(".service-provider-mobile-number").numeric();
});