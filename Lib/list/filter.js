var zebra, clearFilterText, form, table, noResultsSpan, noResults, clearFilterLink, clearFilterButton, noResultsText, searchFieldText, filterTable, input, clearSearch;

function prepareEvents() {
    'use strict';
    input.onfocus = function () { if (this.value === searchFieldText) { this.value = ""; } };
    input.onblur = function () { if (this.value === "") { this.value = searchFieldText;  } };
    input.onkeyup = function () { filterTable(input, table); };
    clearFilterButton.onclick = function () { clearSearch(true); };
    clearFilterLink.onclick = function () { clearSearch(false); };
    form.onsubmit = function () { return false; };
    if (document.getElementById('di-fixed')) {
        window.onscroll = checkPos;
    }
    window.onresize = filterBoxPos;
}

function prepareFilter() {
    table = document.getElementById('di-mainTable');
    form = document.createElement('form');
    input = document.createElement('input');
    noResults = document.createElement('p');
    noResultsSpan = document.createElement('span');
    clearFilterLink = document.createElement('a');
    clearFilterButton = document.createElement('input');
    zebra = "di-odd";
    if (clearFilterText === '' || clearFilterText === undefined) { clearFilterText = "clear filter"; }
    if (noResultsText === '' || noResultsText === undefined) { noResultsText = "No results for"; }
    if (searchFieldText === '' || searchFieldText === undefined) { searchFieldText = "filter..."; }

    form.setAttribute('class', 'di-filter');
    form.attributes['class'].value = 'di-filter';

    input.setAttribute('class', 'di-searchField');
    input.attributes['class'].value = 'di-searchField';
    input.value = searchFieldText;
    form.appendChild(input);
    document.getElementById('di-header').appendChild(form);

	setTableWidth();

    noResults.className = 'di-noResults';
    noResults.style.display = 'none';
    noResults.appendChild(noResultsSpan);
    table.parentNode.appendChild(noResults);

    clearFilterLink.className = 'di-clearFilterLink';
    clearFilterLink.innerHTML = clearFilterText;
    clearFilterButton.setAttribute('type', 'button');
    clearFilterButton.className = 'di-clearFilterButton';
    clearFilterButton.value = 'x';
    clearFilterButton.style.display = 'none';
    form.appendChild(clearFilterButton);

	for (i = 1; i < table.getElementsByTagName('tbody')[0].getElementsByTagName('tr').length; i += 2) {
		table.getElementsByTagName('tbody')[0].getElementsByTagName('tr')[i].className = 'di-even';
	}
}

function setTableWidth() {
	var i, thead = document.getElementById("di-mainTable").getElementsByTagName('th');
    for (i = 0; i < thead.length; i++) {
		var currWidth = Math.round(parseInt(thead[i].offsetWidth, 10));
        thead[i].setAttribute("style", "width: " + currWidth + "px;");
    }
}

var filterBoxPos = function  () {
    if (table.offsetWidth > document.documentElement.offsetWidth) {
        form.setAttribute('id', 'di-fixed');
        form.attributes.id.value = 'di-fixed';
    } else {
        form.removeAttribute('id');
    }
}

var checkPos = function () {
        var pageY = !isNaN(window.pageYOffset) ? window.pageYOffset : document.documentElement.scrollTop;
        form.style.display = (pageY > 50) ? 'none' : 'block';
	};

function clearSearch(focus) {
    'use strict';
	input.value = "";
	filterTable(input, table);
	input.value = searchFieldText;
    if (focus === true) { input.focus(); }
}

function filterTable(term, table) {
    'use strict';
	var terms = term.value.toLowerCase().split(" ");
    var counter = 0, i, r, display, rowCount = 0;
	for (r = 1; r < table.rows.length; r += 1) {
		display = '';
        
		for (i = 0; i < terms.length; i += 1) {
			if (table.rows[r].innerHTML.replace(/<[^>]+>/g, "").toLowerCase().indexOf(terms[i]) < 0) {
				display = 'none';
			}
			table.rows[r].style.display = display;
		}

		if (display === '') {
			if (counter === 0) { zebra = "di-odd"; }
			table.rows[r].className = zebra;
			zebra = (zebra === "di-odd") ? "di-even" : "di-odd";
			counter++;
		}
	}

	for (i = 1; i < table.rows.length; i++) {
		if (table.rows[i].style.display === 'none') { rowCount++; }
	}

	var totalRows = table.getElementsByTagName('tbody')[0].getElementsByTagName('tr').length;

	var filtered = (rowCount > 0) ? " / " + totalRows : "";
	document.getElementById('di-count').innerHTML = totalRows - rowCount + filtered;

	if (rowCount === table.rows.length - 1) {
		noResultsSpan.innerHTML = noResultsText + "&nbsp;\"" + input.value + "\". ";
		noResults.appendChild(clearFilterLink);
		noResults.style.display = 'block';
	} else {
		noResults.style.display = 'none';
	}

	clearFilterButton.style.display = (input.value !== '' && input.value !== searchFieldText) ? 'block' : 'none';
}

addLoadEvent(function() {
	prepareFilter();
	prepareEvents();
});