var imgLink, aLinks, minilightbox;

aLinks = document.getElementById('di-mainTable').getElementsByTagName('a');

for (i = 0; i < aLinks.length; i++) {
    imgLink = aLinks[i].href.match(/\.(?:jpg|gif|png|webp)/gi);
    if (imgLink !== null) {
        aLinks[i].setAttribute('rel', 'di-mini-lightbox');
        aLinks[i].setAttribute('title', decodeURI(aLinks[i].href.substring(aLinks[i].href.lastIndexOf("/") + 1, aLinks[i].href.length)));
		aLinks[i].innerHTML = "View";
    }
}

function listen(ob, ev, fn) {
    'use strict';
	if (ob.addEventListener) {
        ob.addEventListener(ev, fn, false);
        return true;
    } else if (ob.attachEvent) {
        ob.attachEvent('on' + ev, fn);
        return true;
    } else {
        return false;
    }
}

function ImageLoader(url) {
	this.url = url;
	this.image = null;
	this.loadevent = null;
}

ImageLoader.prototype.load = function () {
    'use strict';
	this.image = document.createElement('img');
	var url = this.url;
	var image = this.image;
	var loadevent = this.loadevent;
	listen(this.image, 'load', function () { if (loadevent !== null) { loadevent(image); } }, false);
	this.image.src = this.url;
};

ImageLoader.prototype.getimage = function () {
	return this.image;
};

function mini_lightbox_close() {
    'use strict';
	document.getElementById('di-minilightbox').style.display = 'none';
	document.getElementsByTagName('body')[0].removeChild(minilightbox);
}

function mini_lightbox(image_path, text) {
    'use strict';
	minilightbox = document.createElement('div');
	minilightbox.setAttribute('id', 'di-minilightbox');
	var mlbx_bg = document.createElement('div');
	mlbx_bg.setAttribute('id', 'di-minilightbox-background');
	mlbx_bg.onclick = function () { mini_lightbox_close(); };
	var mlbx_cnt = document.createElement('div');
	mlbx_cnt.setAttribute('id', 'di-minilightbox-content');
	var mlbx_img_cnt = document.createElement('div');
	mlbx_img_cnt.setAttribute('id', 'di-minilightbox-image-container');
	var mlbx_img = document.createElement('img');
	mlbx_img.setAttribute('id', 'di-minilightbox-image');
	mlbx_img.setAttribute('src', image_path);

	var mlbx_cls = document.createElement('div');
	mlbx_cls.setAttribute('id', 'di-minilightbox-closebutton');
	mlbx_cls.innerHTML = '<a href="javascript:mini_lightbox_close();" title="close">&times;</a>';

	if (typeof (text) !== 'undefined') {
		var mlbx_txt = document.createElement('div');
		mlbx_txt.setAttribute('id', 'di-minilightbox-text');
		mlbx_txt.innerHTML = unescape(text);
	}

	document.getElementsByTagName('body')[0].appendChild(minilightbox);
	minilightbox.appendChild(mlbx_bg);
	minilightbox.appendChild(mlbx_cnt);
	mlbx_cnt.appendChild(mlbx_img_cnt);
	mlbx_img_cnt.appendChild(mlbx_img);
	mlbx_cnt.appendChild(mlbx_cls);
	if (typeof (text) !== 'undefined') { mlbx_cnt.appendChild(mlbx_txt); }
	
	
var theWidth, theHeight;
	if (window.innerWidth) {
		theWidth=window.innerWidth;
	} else if (document.documentElement && document.documentElement.clientWidth) {
		theWidth=document.documentElement.clientWidth;
	} else if (document.body) {
		theWidth=document.body.clientWidth;
	} if (window.innerHeight) {
		theHeight=window.innerHeight;
	} else if (document.documentElement && document.documentElement.clientHeight) {
		theHeight=document.documentElement.clientHeight;
	} else if (document.body) {
		theHeight=document.body.clientHeight;
}
	
	var loader = new ImageLoader(image_path);
	var maxHeight = Math.floor(theHeight * 0.8);
	var maxWidth = Math.floor(theWidth * 0.8);
	
	loader.loadevent = function (image) {
		mlbx_cnt.style.left = '50%';
		mlbx_cnt.style.top = '50%';
		
		var imgWidth = document.getElementById('di-minilightbox-image').width;
		var imgHeight = document.getElementById('di-minilightbox-image').height;
		
		if(imgWidth > maxWidth || imgHeight > maxHeight) {
			if (imgWidth/imgHeight < maxWidth/maxHeight ) {
				document.getElementById('di-minilightbox-image').height = maxHeight;
			} else {
				document.getElementById('di-minilightbox-image').width = maxWidth;
			}
		}
		
		mlbx_cnt.style.visibility = 'hidden';
		mlbx_cnt.style.display = 'block';
		mlbx_cnt.style.marginLeft = '-' + Math.round((mlbx_cnt.offsetWidth + 20) / 2) + 'px';
		mlbx_cnt.style.marginTop = '-' + Math.round(mlbx_cnt.offsetHeight / 2) + 'px';
		mlbx_bg.style.backgroundImage = 'none';
		mlbx_cnt.style.visibility = 'visible';
	};
	loader.load();
}
function get_lightboxed() {
    'use strict';
	for (i = 0; i < aLinks.length; i++) {
		if (aLinks[i].getAttribute("rel") === "di-mini-lightbox") {
			aLinks[i].onclick = function () {
				mini_lightbox(this.href, decodeURI(this.title));
				return false;
			};
		}
	}
}

addLoadEvent(get_lightboxed);