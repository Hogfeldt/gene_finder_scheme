
data := data/*.fa
datascm := $(patsubst data/%.fa,data/%.scm,$(data))

$(datascm): $(data)
	python scripts/fasta_to_scheme.py

model.scm: $(datascm)
	scheme-exe train_model.scm 2>&1 >/dev/null | \
		awk '{print "(define model "$$0")"}' > model.scm

.PHONY: clean
clean: 
	rm $(datascm) model.scm
