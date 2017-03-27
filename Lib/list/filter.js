if(!clearFilterText || clearFilterText == '') var clearFilterText = "clear filter";
if(!noResultsText || noResultsText == '') var noResultsText = "No results for";
if(!searchFieldText || searchFieldText == '') var searchFieldText = "filter...";

var zebra = "odd";
function filterTable(term, table) {
	var terms = term.value.toLowerCase().split(" ");
	var counter = 0;
	for (var r = 1; r < table.rows.length; r++) {
		var display = '';

		for (var i = 0; i < terms.length; i++) {
			if (table.rows[r].innerHTML.replace(/<[^>]+>/g, "").toLowerCase().indexOf(terms[i]) < 0) {
				display = 'none';
			}
			table.rows[r].style.display = display;
		}

		if(display == '') {
			if(counter == 0) zebra = "odd";
			table.rows[r].className = zebra;
			(zebra == "odd") ? zebra = "even" : zebra = "odd";
			counter++;
		}
	}

	var rowCount = 0;
	for (var i = 1; i < table.rows.length; i++) {
		if (table.rows[i].style.display == 'none') { rowCount++; }
	}

	var totalRows = table.getElementsByTagName('tbody')[0].getElementsByTagName('tr').length;

	var filtered = (rowCount > 0) ? " / " + totalRows : "";
	document.getElementById('count').innerHTML = totalRows - rowCount + filtered;

	var thead = table.getElementsByTagName('thead')[0];

	if (rowCount == table.rows.length - 1) {
		noResultsSpan.innerHTML = noResultsText + "&nbsp;\"" + input.value + "\". ";
		noResults.appendChild(clearFilterLink);
		noResults.style.display = 'block';
	} else {
		noResults.style.display = 'none';
	}

	(input.value != '' && input.value != searchFieldText) ? clearFilterButton.style.display = 'block' : clearFilterButton.style.display = 'none';
}

var table = document.getElementById('mainTable');

var form = document.createElement('form');
form.setAttribute('class', 'filter');

form.attributes['class'].value = 'filter';
var input = document.createElement('input');
input.setAttribute('class','searchfield');
input.attributes['class'].value = 'searchField';
input.value = searchFieldText;
input.onfocus = function() { if(this.value == searchFieldText) { this.value = "";  } }
input.onblur = function() { if(this.value == "") { this.value = searchFieldText;  } }
input.onkeyup = function() { filterTable(input, table); }
form.appendChild(input);
document.getElementById('header').appendChild(form);

for(i=0; i < table.getElementsByTagName('th').length; i++) {
	currThead = document.getElementsByTagName('th')[i];
	currThead.setAttribute("style", "width: " + Math.round(parseInt(currThead.offsetWidth)) + "px !important;");
}
table.setAttribute("style", "width: " + parseInt(table.offsetWidth) + "px !important;");

var noResults = document.createElement('p');
var noResultsSpan = document.createElement('span');
noResults.className = 'noResults';
noResults.style.display = 'none';
noResults.appendChild(noResultsSpan);
table.parentNode.appendChild(noResults);

var clearFilterLink = document.createElement('a');
clearFilterLink.className = 'clearFilterLink';
clearFilterLink.innerHTML = clearFilterText;
clearFilterLink.onclick = function() { clearSearch(false) };

var clearFilterButton = document.createElement('input');
clearFilterButton.setAttribute('type','button');
clearFilterButton.className = 'clearFilterButton';
clearFilterButton.value = 'x';
clearFilterButton.style.display = 'none';
document.getElementsByTagName('form')[0].appendChild(clearFilterButton);
clearFilterButton.onclick = function() { clearSearch(true) };

function clearSearch(focus) {
	input.value = "";
	filterTable(input, table);
	input.value = searchFieldText;
	focus == true ? input.focus(): "";
}

form.onsubmit = function() { return false; }

var dummy = document.createElement('div');
dummy.value = "";
filterTable(dummy, table);

if(table.offsetWidth > document.documentElement.offsetWidth) { 
	form.setAttribute('id','fixed');
	form.attributes['id'].value = 'fixed';
}

var checkPos = function() {
	pageY = !isNaN(window.pageYOffset) ? window.pageYOffset : document.documentElement.scrollTop;
	(pageY > 50) ? form.style.display = 'none' : form.style.display = 'block';
}

if (document.getElementById('fixed')) window.onscroll = checkPos;