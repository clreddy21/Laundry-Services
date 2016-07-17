$(document).ready(function() {
    $('.fa-clock-o').click(function(){
        $(this).siblings('[type="text"]').focus().click();
    })

    $('.best_in_place').best_in_place()
});
