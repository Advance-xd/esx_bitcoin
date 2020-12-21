var inMenu = false
var activeSelected = null
var activeMenu = null

let bitcoins = 0;
let graphics = 0;

$(function() {
    addEventListener('message', function(event) {
        bitcons = event.data.bitcoins;
        if(event.data.type == "open") {
            $('#waiting').show();
            $('body').addClass("active");
            
            
            $('.money').html(event.data.bitcoins);
            $('.price').html(event.data.price);
            
        } else if(event.data.type == "update"){
            bitcoins = event.data.bitcoins;
            graphics = event.data.graphics;
            $('.money').html(event.data.bitcoins);
            $('.price').html(event.data.price);

        } else if(event.data.type == "close"){ 
            close()
        } else if(event.data.type == "balance") {
            $('.name').html(event.data.player);
            $('.money').html(event.data.bitcoins);
        } else if(event.data.type == "list") {
            $("#companies tbody").empty();

            var array = event.data.cache
            for (var e in array) {
                var obj = array[e];

                if(obj.rate == "up") {
                    var icon = "fa-arrow-up"
                } else if(obj.rate == "down") {
                    var icon = "fa-arrow-down"
                } else {
                    var icon = "fa-circle"
                }

                $('#companies tbody').append(`
                    <tr data-label='${obj.label}'>
                        <th>${obj.name}</th>
                        <th><i class='fas ${icon}'></i> ${obj.stock}</th>
                    </tr>`)
            }
        } else if(event.data.type == "all") {
            $("#all tbody").empty();
            graphics = event.data.graphics + 1;
            for ( var e = 1; e < graphics; e++ ) {
                var obj = graphics[e];

                /*if(obj.active) {
                    var sold = "No"
                } else {
                    var sold = "Yes"
                }*/

                $('#all tbody').append(`
                    <tr>
                        <th>Grafikkort ${e}</th>
                        <th>99.9</th>
                        <th>69</th>
                    </tr>`)
                    
            }
        } else if(event.data.type == "sell") {
            $("#sell tbody").empty();
            
            var array = event.data.cache
            for (var e in array) {
                var obj = array[e];
                
                var intrest = obj.investRate - obj.rate
                intrest = parseFloat(intrest).toFixed(2)
                
                if(intrest > 0) {
                    var icon = "fa-arrow-up"
                } else if(intrest < 0) {
                    var icon = "fa-arrow-down"
                } else {
                    var icon = "fa-circle"
                }

                $('#sell tbody').append(`
                    <tr data-label='${obj.label}'>
                        <th>${obj.name}</th>
                        <th>${obj.amount}</th>
                        <th><i class='fas ${icon}'></i> ${intrest}</th>
                    </tr>`)
            }
        }
    });
});

$('#fingerprint-content').click(function(){
    $('.fingerprint-active, .fingerprint-bar').addClass("active")
    var watitime = 600
    if (bitcoins == 0){
        watitime = 1500;
    }
    setTimeout(function(){
        $('#general').css('display', 'block')
        $('#topbar').css('display', 'flex')
        $('#waiting').css('display', 'none')
        $('.fingerprint-active, .fingerprint-bar').removeClass("active")
    }, watitime);
})

$('#close').click(function() {
    if(!inMenu) {
        close()
    } else {
        mainPage()
    }
})

// Input activate submit button
$('.input-cont input').on("input", function(e) {
    // console.log(e);
    var input = e.target.value
    //var isnum = /^\d+$/.test(input)
    
    if(input >= bitcoins && input < 0) {
        var button = e.target.parentElement.parentElement.lastElementChild

        buttonHandle(button, false)

    }
    var parent = e.currentTarget.parentElement.parentElement.parentElement
    var active = $(parent).find('table > tbody > .active')[0]
    
    
    if(input <= bitcoins && input > 0) {
        var button = e.target.parentElement.parentElement.lastElementChild
        buttonHandle(button)
    }
})

// Process investments
$('form .btn').click(function (e) {
    //console.log(e)
    e.preventDefault();
    var div = e.currentTarget.parentElement.parentElement
    var form = e.currentTarget.parentElement
    var inputValue = $(form).find("input[type='number']")[0] || null
    //if(!inputValue || /^\d+$/.test(inputValue.value)) {
        if(inputValue != null) inputValue = inputValue.value
        var trActive = $(div).find('table > tbody > .active')[0]

        var label = $(trActive).data("label")
        var rate = $(trActive).children().last().text()
        rate = parseFloat(rate.substr(1))

        if (activeMenu == "sell") {
            if (inputValue <= bitcoins && inputValue > 0) {
                $.post('http://esx_bitcoin/sold', JSON.stringify({bc: inputValue}))
            } else { 
                $.post('http://esx_bitcoin/error', JSON.stringify({}))
            }
        } else if(activeMenu == "buy") {
            //$.post('http://esx_invest/buyInvestment', JSON.stringify({job: label, amount: inputValue, boughtRate: rate}))
        }

        mainPage()
    //}
})

// On table click process activiation + submition
$('table').click(function(e) {
    var target = $(e.target)
    
    if(target.is("th")) {
        target = target[0].parentElement
    } else if(!target.is("tr")) {
        return;
        // wtf happend where did he press?
    }

    var currentForm = $(target).closest('div').children("form")[0];
    var selectedName = $(target).data("label");
    if(selectedName != null) {
        $(currentForm).data("label", selectedName)

        if(activeSelected != null) {
            $(activeSelected).removeClass("active")
        }

        $(target).addClass("active")
        activeSelected = target

        if(activeMenu == "sell") {
            var button = $('#sellUI').children().last().children().last()
        } else if(activeMenu == "buy") {
            var input = $('#buyUI').find('form > div > input')[0]
            var value = input.value

            if(value != "") {
                var button = $('#buyUI').find('form > button')[0]
            } else {
                button = null
            }
        } else if(activeMenu == "sold") {
            console.log('sold')
        }

        buttonHandle(button)
    }
    
})

$('#new_bank').click(function() {
    //$.post('http://esx_invest/newBanking', "{}")
})

// GENERAL
$('#buy').click(function() {
    $('#general').hide();
    $('#buyUI').show();
    $('#close').html("Back <i class='fas fa-sign-out-alt'></i>");
    //$.post('http://esx_invest/list', "{}")
    inMenu = true
    activeMenu = "buy"
})

$('#all').click(function() {
    $('#general').hide();
    $('#allUI').show();
    $('#close').html("Back <i class='fas fa-sign-out-alt'></i>");
    $.post('http://esx_bitcoin/all', "{}")
    inMenu = true
    activeMenu = "all"
})

$('#sell').click(function() {
    $('#general').hide();
    $('#sellUI').show();
    $('#close').html("Back <i class='fas fa-sign-out-alt'></i>");
    //$.post('http://esx_invest/sell', "{}")
    inMenu = true
    activeMenu = "sell"
})

$('.back').click(function(){
    mainPage()
})

document.onkeyup = function(data){
    if (data.which == 27){
        close()
    }
}

function buttonHandle(button, activate = true) {
    
    
    if(typeof button != "object") return false;

    if(activate) {
        $(button).css("opacity", 1)
        $(button).css("pointer-events", "all")
    } else {
        $(button).css("opacity", 0.6)
        $(button).css("pointer-events", "none")
    }
}

function mainPage() {
    $('#close').html("Close <i class='fas fa-sign-out-alt'></i>");
    $('#buyUI, #allUI, #sellUI').hide();
    $('#general').show();
    inMenu = false
    $.post('http://esx_invest/balance', "{}")
}

function close() {
    $('#general, #waiting, #sellUI, #allUI, #buyUI, #topbar').hide();
    $('body').removeClass("active");
    $.post('http://esx_bitcoin/close', "{}");
}