<?php

function arrayToXml($data, $xml) {
    foreach ($data as $key => $value) {
        if (is_array($value)) {
            $childNode = $xml->addChild($key);
            arrayToXml($value, $childNode);
        } else {
            $xml->addChild($key, htmlspecialchars($value));
        }
    }
}

$site = json_decode(file_get_contents("https://api.b365api.com/v1/bwin/inplay?token=167796-lKPUv4aEu1M9so"));
$xml = new SimpleXMLElement('<?xml version="1.0" encoding="UTF-8"?><Maclar></Maclar>');

foreach ($site->liveEvents as $live) {

$oyunid = isset($live->event->id) ? $live->event->id : 0;
$oyundurum = isset($live->event->state) ? $live->event->state : 'Unknown';
$awayName = isset($live->event->awayName) ? $live->event->awayName : 'Unknown';
$homeName = isset($live->event->homeName) ? $live->event->homeName : 'Unknown';
$baslangic = isset($live->event->start) ? $live->event->start : 'Unknown';
$dakika = isset($live->liveData->matchClock->minute) ? $live->liveData->matchClock->minute : 0;
$saniye = isset($live->liveData->matchClock->second) ? $live->liveData->matchClock->second : 0;
$oynuyormu = isset($live->liveData->matchClock->running) ? $live->liveData->matchClock->running : 0;
$periyot = isset($live->liveData->matchClock->period) ? $live->liveData->matchClock->period : 0;
$skorhome = isset($live->liveData->score->home) ? $live->liveData->score->home : 0;
$skoraway = isset($live->liveData->score->away) ? $live->liveData->score->away : 0;
$skor = $skorhome . "-" . $skoraway;
$sporadi = isset($live->event->path[0]->name) ? $live->event->path[0]->name : 'Unknown';
$ligid = isset($live->event->groupId) ? $live->event->groupId : 0;
$ligisim = isset($live->event->group) ? $live->event->group : 'Unknown';
$ulkeisim = isset($live->event->path[1]->name) ? $live->event->path[1]->name : 'Unknown';
$ulkeid = isset($live->event->path[1]->id) ? $live->event->path[1]->id : 0;
$ulkeslug = isset($live->event->path[1]->termKey) ? $live->event->path[1]->termKey : 'Unknown';
$oranadet = isset($live->event->liveBoCount) ? $live->event->liveBoCount : 0;
$sport = isset($live->event->sport) ? $live->event->sport : 'Unknown';

/*
"4" => "Futbol",
"7" => "Basketbol",
"12" => "Buz Hokeyi",
"5" => "Tenis",
"18" => "Voleybol",
"16" => "Hentbol",
"33" => "Bilardo",
"22" => "Kriket",
"31" => "Ragbi",
"6" => "Formüla 1",
"11" => "Amerikan Futbolu",
"44" => "Badminton",
"56" => "Masa Tenisi",
"10" => "Bisiklet",
"23" => "Beyzbol",
"100" => "E-Sports",
"13" => "Golf",
"40" => "Motorsiklet",
"34" => "Dart",
"70" => "Futsal",
"9" => "Alpler Kayak",
"32" => "Rugby Birligi",
"31" => "Rugby Ligi",
"36" => "Avustralya futbolu",
*/

switch ($sport) {
case 'FOOTBALL':
$sportid = 4;
break;
case 'BASKETBALL':
$sportid = 7;
break;
case 'VOLLEYBALL':
$sportid = 18;
break;
case 'TENNIS':
$sportid = 351;
break;
case 'BASEBALL':
$sportid = 5;
break;
case 'TABLE_TENNIS':
$sportid = 56;
break;
default:
$sportid = 9999;
break;
}

$matchData = [
"id" => (int)$oyunid,
"sportid" => (int)$sportid,
"skor" => $skor,
"baslangic" => $baslangic,
"dakika" => $dakika,
"sure_detay" => $periyot,
"oynuyormu" => (int)$oynuyormu,
"aktifmi" => (int)1,
"ulke" => $ulkeisim,
"ulke_id" => $ulkeid,
"lig" => $ligisim,
"lig_id" => $ligid,
"oran_adet" => (int)$oranadet,
"tip" => $sporadi,
"tur" =>$sporadi,
"evsahibi_isim" => $homeName,
"misafir_isim" => $awayName
];


$macNode = $xml->addChild('Mac', ' ');
foreach ($matchData as $key => $value) {
$macNode->addAttribute($key, htmlspecialchars($value));
}

}

header('Content-Type: text/xml');
echo $xml->asXML();

?>