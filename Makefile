
data := data/*.fa
datascm := $(patsubst data/%.fa,data/%.scm,$(data))
predictions := predictions/pred-ann{6,7,8,9,10}.fa

$(datascm): $(data)
	python scripts/fasta_to_scheme.py

model.scm: $(datascm)
	scheme-exe train_model.scm 2>&1 >/dev/null | \
		scripts/model_print_to_scheme.py > model.scm

pred_out.txt: model.scm
	scheme-exe predict_genes.scm

.PHONY: clean
clean: 
	rm $(datascm) model.scm
