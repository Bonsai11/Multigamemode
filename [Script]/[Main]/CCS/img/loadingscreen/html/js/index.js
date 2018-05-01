document.body.style.zoom = 0.2 + window.innerHeight / 1080 * 0.8;

var body = document.querySelector("body");

function loaded() {
    body.className += " animate";
}

window.onload = function() {
    loaded();
};

function changeColor(hex) {
    document.querySelector('#one').style.color = hex;
    document.querySelector('#two-small').style.color = hex;
	document.querySelector('#loader').style.color = hex;
	document.querySelector('#carRot').style.fill = hex;
    document.querySelector('body').style.backgroundColor = "#000000";//ColorLuminance(hex, -0.9);
}

function setProgress(progress) {
	document.querySelector('#loader').innerHTML = progress;
}


function ColorLuminance(hex, lum) {
    hex = String(hex).replace(/[^0-9a-f]/gi, '');
    if (hex.length < 6) {
        hex = hex[0] + hex[0] + hex[1] + hex[1] + hex[2] + hex[2];
    }
    lum = lum || 0;
    var rgb = "#",
        c, i;
    for (i = 0; i < 3; i++) {
        c = parseInt(hex.substr(i * 2, 2), 16);
        c = Math.round(Math.min(Math.max(0, c + (c * lum)), 255)).toString(16);
        rgb += ("00" + c).substr(c.length);
    }
    return rgb;
}

var anim1 = document.getElementById("one");
var anim1big = document.getElementById("one-big");
var anim2 = document.getElementById("two");
var anim2small = document.getElementById("two-small");
var players = ["BONSAI", "TABO", "N!KO", "TIGER", "^_^", "KINGZZ", "DIMA", "MYETZ", "CLICKYY", "STIFLER", "YIGITHAN", "ONLYTIME", "FORLAN", "ER1K", "ADOMER", 
			"DAINDY", "MOS", "THE_DUDE", "DINNER", "MR.DRAKE", "JULIAN", "RAYOKKZ", "AJ", "SEBAZ", "KITT", "MILKEH", "SHOK", "TRYHARD", "TEMPLER", 
			"OLUCHNA", "JOHNNY", "RENKON", "LARSKEE", "DARKNESS", "MR.SKOL", "INFERNO", "QWINCE", "TROSKY", "SPACE", "MONKSUN", "BERTO", "ANGEL", "PENDEX", 
			"ZUNE", "MICHAEL", "VODKA", "MONSTER", "COLD", "JAPA", "HUNTER", "BUSHIDO", "KURATO", "VIRTU", "SEISH", "KNASKRIPPA", "PROJECTX", 
			"TOYKO", "ROXUS", "DEVISUNNNN", "WIND", "HITSU", "WILSON", "GJENTIB", "WEED", "JAYER", "SNIPER", "SAMUPEGA", "EVIL15", "REPLAY", "NIRAX", 
			"LIGHTNING", "NEXON", "WAYLON", "FALKEN", "POLLA", "TECLA", "DEATHNOTE", "POKEX", "NOHEAR43", "NUTZ", "MAJESTIC", "SAPE", "BOULI", "SKYKNIGHT", 
			"MYHAX", "ELUZIVE", "MR.MONKEY", "SANDOWSKI", "ORS", "ROBERT_M", "TAURUS", "BLADE", "LUCHO122", "FERNANDO", "REBEL", "CRAWLER", "STIEG", 
			"SMIRNOV", "MIDHAT", "CHAOSJOY", "RUURD", "4:20", "RYZER!", "ABDE_GAMER", "MR.AZZOZ", "HADI", "XZERO", "PERFEKT", "LIPISIQX", "VINTAGUS", 
			"BULLET", "SKELETON", "CRYS", "HM", "AVENGER", "DREAMER", "THESKATER", "JONHY", "THEONE", "OBSIDIAN", "PLATO", "SNAKE", "D4N1EL", "JOULEX", 
			"NIGGAA", "SEBAS", "JAYZEN", "CRAZYBOY", "GHOST_EGY", "CAIMAN", "KARIM", "REYVESTIA", "LORENZO", "TENSHO", "XTREME", "BLACKANGEL", "YOUNGALP", 
			"KOSTOLOM", "FEAR", "JACKASS", "NO1SE", "KRUZE", "AVEUX", "PROTO", "MRHERZ", "SPEED", "JAX", "SARA", "YAMI", "BREAK", "YIGI", "TECHNO", "XLION",
			"TARGET^", "KAVINSKY", "NEGA", "^SOLIMAN~", "AIRTEAM", "TOXIDO_STYLE", "LYNE", "WINGZ", "ASPHEL", "MOHAMED", "ALIOMAR", "EASYE", "TRUCKER",
			"JASON", "MATEE", "WESLEY", "AIR", "JAKE", "MATTOWSKI", "EXSSV", "KRANZ", "REACTX", "REDWARRIOR", "N0PE", "ELECTROMANZY~", "DUFF", "TIGERCLAW",
			"MIGHTYFIRE", "KHAKIONE0", "MIKKZ", "SKEMA", "SCORPION", "ONLYTIME", "FRANK", "LILGERA", "LUDI", "ROXUS", "MIHA", "SAMMY", "CAT MASTER", "BUSHIDO",
			"DEATHNOTE", "ANASS"];


function setPlayers(data) {
    players = JSON.parse(JSON.stringify(data));
}

anim1.innerHTML = players[Math.floor(Math.random() * players.length)];
anim1big.innerHTML = players[Math.floor(Math.random() * players.length)];
anim2.innerHTML = players[Math.floor(Math.random() * players.length)];
anim2small.innerHTML = players[Math.floor(Math.random() * players.length)];

anim1.addEventListener("webkitAnimationIteration", onFirstAnim);
anim1big.addEventListener("webkitAnimationIteration", onFirstAnimBig);
anim2.addEventListener("webkitAnimationIteration", onSecondAnim);
anim2small.addEventListener("webkitAnimationIteration", onSecondAnimSmall);

function onFirstAnim() {
    anim1.innerHTML = players[Math.floor(Math.random() * players.length)];
}

function onFirstAnimBig() {
    anim1big.innerHTML = players[Math.floor(Math.random() * players.length)];
}

function onSecondAnim() {
    anim2.innerHTML = players[Math.floor(Math.random() * players.length)];
}

function onSecondAnimSmall() {
    anim2small.innerHTML = players[Math.floor(Math.random() * players.length)];
}

TweenMax.set('#circlePath', {
    attr: {
        r: document.querySelector('#mainCircle').getAttribute('r')
    }
})
MorphSVGPlugin.convertToPath('#circlePath');

var xmlns = "http://www.w3.org/2000/svg",
    xlinkns = "http://www.w3.org/1999/xlink",
    select = function(s) {
        return document.querySelector(s);
    },
    selectAll = function(s) {
        return document.querySelectorAll(s);
    },
    mainCircle = select('#mainCircle'),
    mainContainer = select('#mainContainer'),
    car = select('#car'),
    mainSVG = select('.mainSVG'),
    mainCircleRadius = Number(mainCircle.getAttribute('r')),
    //radius = mainCircleRadius,
    numDots = mainCircleRadius / 2,
    step = 360 / numDots,
    dotMin = 0,
    circlePath = select('#circlePath')

//
//mainSVG.appendChild(circlePath);
TweenMax.set('svg', {
    visibility: 'visible'
})
TweenMax.set([car], {
    transformOrigin: '50% 50%'
})
TweenMax.set('#carRot', {
    transformOrigin: '0% 0%',
    rotation: 30
})

var circleBezier = MorphSVGPlugin.pathDataToBezier(circlePath.getAttribute('d'), {
    offsetX: -20,
    offsetY: -5
})


//console.log(circlePath)
var mainTl = new TimelineMax();

function makeDots() {
    var d, angle, tl;
    for (var i = 0; i < numDots; i++) {

        d = select('#puff').cloneNode(true);
        mainContainer.appendChild(d);
        angle = step * i;
        TweenMax.set(d, {
            //attr: {
            x: (Math.cos(angle * Math.PI / 180) * mainCircleRadius) + 400,
            y: (Math.sin(angle * Math.PI / 180) * mainCircleRadius) + 300,
            rotation: Math.random() * 360,
            transformOrigin: '50% 50%'
                //}
        })

        tl = new TimelineMax({
            repeat: -1
        });
        tl
            .from(d, 0.2, {
                scale: 0,
                ease: Power4.easeIn
            })
            .to(d, 1.8, {
                scale: Math.random() + 2,
                alpha: 0,
                ease: Power4.easeOut
            })

        mainTl.add(tl, i / (numDots / tl.duration()))
    }
    var carTl = new TimelineMax({
        repeat: -1
    });
    carTl.to(car, tl.duration(), {
        bezier: {
            type: "cubic",
            values: circleBezier,
            autoRotate: true
        },
        ease: Linear.easeNone
    })
    mainTl.add(carTl, 0.05)
}

makeDots();
mainTl.time(120);
TweenMax.to(mainContainer, 20, {
    rotation: -360,
    svgOrigin: '400 300',
    repeat: -1,
    ease: Linear.easeNone
});
mainTl.timeScale(1.1)