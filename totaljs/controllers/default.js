const { spawn } = require('child_process');

var scriptpath = '/path/to/script/am-generate-pdf';

exports.install = function() {
	F.route('/', file_download);
};

function file_download() {
	var self = this;
  
  // nota: implementare un metodo che generi uno stream del sorgente (normalmente, dal contenuto del file ars_spells.xml)
  // contenente lo spellbook da generare. Può essere una pagina, il risultato di un file upload etc.
  var sourceStream = 'un qualche stream generato dal sorgente dei files';
  const child = spawn(scriptpath);
  
  sourceStream.pipe(child.stdin);
  
	self.stream('application/pdf', child.stdout, 'ars_magica_grimoire.pdf');
}
