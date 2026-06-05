# ==========================
#   Makefile LaTeX - CESI
# ==========================

# Nom du fichier principal sans extension
MAIN=main

# Commande de compilation
LATEXMK=latexmk
LATEXMK_FLAGS=-pdf -interaction=nonstopmode -file-line-error

# Par défaut : compiler le PDF
all: pdf

# ==========================
#   Compilation
# ==========================
pdf:
	@echo "Compilation du document LaTeX..."
	$(LATEXMK) $(LATEXMK_FLAGS) $(MAIN).tex
	@echo "Compilation terminée ✅"

# ==========================
#   Nettoyage basique
# ==========================
clean:
	@echo "Suppression des fichiers temporaires..."
	rm -f $(MAIN).aux $(MAIN).log $(MAIN).bbl $(MAIN).blg $(MAIN).out $(MAIN).toc $(MAIN).lof $(MAIN).lot $(MAIN).bcf $(MAIN).run.xml \
	$(MAIN).fdb_latexmk $(MAIN).fls $(MAIN).synctex.gz $(MAIN).acr $(MAIN).alg $(MAIN).glg $(MAIN).gls contents/*.aux contents/*.log annexes/*.aux annexes/*.log assets/*.aux assets/*.log
	@echo "Fichiers temporaires supprimés."

# ==========================
#   Nettoyage complet
# ==========================
mrproper: clean
	@echo "Suppression de tous les fichiers générés..."
	rm -f  $(MAIN).nav $(MAIN).snm $(MAIN).vrb $(MAIN).xwm $(MAIN).swo $(MAIN).swp $(MAIN).acn $(MAIN).glo $(MAIN).glsdefs $(MAIN).ist $(MAIN).alg $(MAIN).bbl $(MAIN).blg $(MAIN).fdb_latexmk $(MAIN).fls $(MAIN).synctex.gz $(MAIN).aux $(MAIN).log $(MAIN).out $(MAIN).toc $(MAIN).lof $(MAIN).lot $(MAIN).bcf $(MAIN).run.xml \
	@echo "Tous les fichiers générés ont été supprimés."
