$pdf_mode = 1;
# minted exige -shell-escape pour appeler pygmentize
$pdflatex = 'pdflatex -shell-escape -interaction=nonstopmode -file-line-error %O %S';
