{if $ajax == "3"}
<script>
{literal}

var t;
var a;
var sonid=0;

var refresh;
var ilkmac = 0;

//
var interval;
var ready = 0;

var bets_resp;


$('#main-left').addClass('sidebar-open');


function left_close(id){
    $('#main-left').removeClass('sidebar-open');
    $('.main-overlay').removeClass('show');
    $("html").removeClass("fix-position");
    $(".livematch-box").removeClass('livematch-active');
    $("[mac-id='"+ id +"']").addClass('livematch-active');

}

function handleImageError(imageElement) {
    // Resimi değiştir
        // console.log("handleImageError tetiklendi!"); // Bu satırı ekleyin

    imageElement.src = '/images/sports-icon/E-Sports.png';
    
    // left-text elementini bul
    var leftTextElement = $(imageElement).parent().next(".left-text");
    
    // left-text içeriğini değiştir
    // if(leftTextElement.length > 0) {
    //     leftTextElement.text('Diğerleri');
    // }
}

// function changeDetailedContent() {
//     $("#livematchdetail").empty();
//     $("#livematchdetail").append('<div class="headernew">   <div class="breadcrumbs">    <span>1</span> </div>' +
//     		    '<div class="events"> <div class="ev-sahibi"> <div class="name">name</div> <div class="text">text</div> </div>' +
//     		        '<div class="stats"> <div class="skor">skor</div> <div class="time"> <span>time</span> </div> </div>' +
//     		        '<div class="deplasman"> <div class="name">name</div> <div class="text">MİSAFİR</div> </div> </div>' +
//     		    '<div class="tv"> <img src="https:/assets/images/tv.png"> </div> </div>')

// }


function livedetails(id, status, intervalStatus){
    
    if ( ready == 0 ) {
        if ( intervalStatus == 1 ) {
            $("#live_event_info").hide();
            $("#liveLoaders").show();
        }
        ready = 1;
        $.ajax({
            url:"/sports/livedetails/"+id,
            success:function(data){
                history.pushState(null, null,'/live/events/'+ id);
                 $('#livematchdetail').html(data);
                 ready = 0;
                 if ( intervalStatus == 1 ) {
                        GetTracker(id);
                        $("#liveLoaders").hide();
                        $("#live_event_info").show();

                }
            }
        });
    } else return false;

}

function organizeEventsBySport(response) {
    const organizedResponse = {};

    $.each(response.results, function(index, event) {
        const sportName = getSportName(event.sport_id);

        if (sportName) {
            if (!organizedResponse[sportName]) {
                organizedResponse[sportName] = [];
            }

            organizedResponse[sportName].push(event);
        }
    });

    return organizedResponse;
}

function getSportName(sportId) {
    const sportsMapping = {
    "1": "Soccer",
    "18": "Basketball",
    "13": "Tennis",
    "91": "Volleyball",
    "78": "Handball",
    "16": "Baseball",
    "2": "Horse Racing",
    "4": "Greyhounds",
    "17": "Ice Hockey",
    "14": "Snooker",
    "12": "American Football",
    "3": "Cricket",
    "83": "Futsal",
    "15": "Darts",
    "92": "Table Tennis",
    "94": "Badminton",
    "8": "Rugby Union",
    "19": "Rugby League",
    "36": "Australian Rules",
    "66": "Bowls",
    "9": "Boxing",
    "75": "Gaelic Sports",
    "90": "Floorball",
    "95": "Beach Volleyball",
    "110": "Water Polo",
    "107": "Squash",
    "151": "E-sports",
    "162": "MMA",
    "148": "Surfing"
    };

    return sportsMapping[sportId];
}

setInterval(function(){
    livedetails(window.location.pathname.split('/')[3], 'true', 0);
}, 30000);

$.liveMatches = function() {
    var maclar_ids = {};
    var ulkeler_slugs = {};
    var sporlar_ids = {};

    $.ajax({
    url: "/services/getLiveMatches",
    dataType: "json",
    success: function(c) {
        
        // Ensure response is successful
        if (!c.success) {
            console.error("Error: Response not successful");
            return;
        }
        else {
            bets_resp = c;
            var processed_resp = organizeEventsBySport(c);
            console.log(processed_resp);
        }

        var Sporlar = Object.keys(processed_resp);      //types of sports-football basketball tennis..
        console.log('Sporlar:'+Sporlar);
            

        if ( ilkmac == 0 ) {

            ilkmac = processed_resp[ Sporlar[0] ][Object.keys(processed_resp[ Sporlar[0] ])[0]].id;
        
            livedetails(ilkmac,'true',1);
            
            refresh = ilkmac;
            
        }

        $.each( processed_resp, function(i, val) {
            var Spor = i;
            
            //iterate through football matches
            
            if ( $("#sport-" + val[Object.keys(val)[0]].sport_id).size() == 0 ) {
                

                if (val[Object.keys(val)[0]].sport_id == 1) {//if sport type is Football collapse it
                    var collapsed = "collapsed";
                    var colin = "in";
                } else {
                    var collapsed = "";
                    var colin = "";
                }

                $(".bultenler").append('<div id="liveSportMenux" class="megadiv ' + collapsed +  '" data-toggle="collapse" sport-id="' + val[Object.keys(val)[0]].sport_id + '" onclick="resize();" data-target="#sport-' + val[Object.keys(val)[0]].sport_id + '">' + '<h4 aria-expanded="true">' + '<div class="leftdiv"> <img src="/images/sports-icon/' + Spor + '.png" onerror="handleImageError(this)" /></div>' + '<div class="left-text">' + Spor + '</div>' + '<div class="rightdiv"><span id="b1">' + Object.keys(val).length + '</span></div>' + '</h4>' + '</div>' + '<div class="collapse ' + colin +  '" sport-id="' + val[Object.keys(val)[0]].sport_id + '" id="sport-' + val[Object.keys(val)[0]].sport_id + '"></div>');
            } else {
                console.log("size=" + $("#sport-" + val[Object.keys(val)[0]].sport_id).size());
                
                $("[data-target='#sport-"+ val[Object.keys(val)[0]].sport_id +"'] #b1").html( Object.keys(val).length );
            }

            $.each(val, function(index, match) {
                var mac_id = match['id'];
                var mac = match;

                maclar_ids[mac_id] = true;
                ulkeler_slugs[mac['sport_id'] + "_" + mac['league']['id']] = true;
                sporlar_ids[mac['sport_id']] = true;

                // ok
                if ($("[ulke='"+ mac['sport_id'] +"_"+ mac['league']['id'] +"']").size() == 0) {
                    $("#sport-" + mac['sport_id']).append('<div ulke="'+ mac['sport_id'] +'_'+ mac['league']['id'] +'" class="countryone collapsed" data-toggle="collapse" data-target="#matches-'+mac['league']['id']+'"><span class="countrynamex">'+ mac['league']['name'] +'</span></div><div id="matches-'+mac['league']['id']+'" class="collapse in" maclar="'+ mac['sport_id'] +'_'+ mac['league']['id'] +'"></div>');
                }

                if ($("[mac-id='"+ mac_id +"']").size() == 0) {
                    $("[maclar='"+ mac['sport_id'] +"_"+ mac['league']['id'] +"']").append('<div mac-id="'+ mac_id +'" class="livematch-box" onclick="livedetails('+ mac_id +',true, 1);left_close('+ mac_id +');"><div class="livematch-info"></div><div class="livematch-name"><p>'+ mac["home"]["name"] +'</p><p>'+ mac['away']['name'] +'</p></div><span class="livematch-score">'+ mac['ss'] +'</span></br><div class="livematch-right"><span class="livematch-detail"> '+ mac['time_status'] +'</span><span class="livematch-minute">'+ mac['sport_id'] +'\' <i class="icon-time"></i></span></div>     </div>');
                } else {
                    $("[mac-id='"+ mac_id +"']").html('<div class="livematch-info"></div><div class="livematch-name"><p>'+ mac["home"]["name"] +'</p><p>'+ mac['away']['name'] +'</p></div><span class="livematch-score">'+ mac['ss'] +'</span></br><div class="livematch-right"><span class="livematch-detail"> '+ mac['time_status'] +'</span><span class="livematch-minute">'+ mac['id'] +'\'<i class="icon-time"></i> </span></div>');
                }
            });


            // Store data in localStorage
            localStorage.setItem('maclar_ids', JSON.stringify(maclar_ids));
            localStorage.setItem('ulkeler_slugs', JSON.stringify(ulkeler_slugs));
            localStorage.setItem('sporlar_ids', JSON.stringify(sporlar_ids));
        });

        
        
        
    }
});


    // localStorage check
    var local_maclar = JSON.parse(localStorage.getItem('maclar_ids')),
        local_ulkeler = JSON.parse( localStorage.getItem('ulkeler_slugs') ),
        local_sporlar = JSON.parse( localStorage.getItem('sporlar_ids') );

    $.each( $("[mac-id]"), function(a,b) {
        if ( typeof local_maclar[$(this).attr('mac-id')] === 'undefined' ) {
            $(this).remove();
        }
    } );

    $.each( $("[maclar]"), function(a,b) {
        if ( typeof local_ulkeler[$(this).attr('maclar')] === 'undefined' ) {
            $("[ulke='"+ $(this).attr('maclar') +"']").remove();
            $(this).remove();
        }
    } );

    $.each( $("[sport-id]"), function(a,b) {
        if ( typeof local_sporlar[$(this).attr('sport-id')] === 'undefined' ) {
            $(this).remove();
        }
    } );


}


$.liveMatches();

setInterval(function(){
   $.liveMatches();
}, 30000);


function resize() {
    setTimeout(function(){
        $('#main-center').height($('.live_left_content').height() + 280);
    }, 300);
}

resize();



</script>

{/literal}
{/if}



<div class="bultenler"></div>