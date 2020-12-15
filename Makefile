
data := data/*.fa
datascm := $(patsubst data/%.fa,data/%.scm,$(data))

$(datascm): $(data)
	python scripts/fasta_to_scheme.py

model.scm: $(datascm)
	scheme-exe train_model.scm 2>&1 >/dev/null | \
		scripts/model_print_to_scheme.py > model.scm

prediction.fa: model.scm
	scheme-exe predict_genes.scm 2>&1 >/dev/null | \
		scripts/pred_to_fasta.py > prediction.fa

.PHONY: clean
clean: 
	rm $(datascm) model.scm
