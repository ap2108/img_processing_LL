TEST ?= 1

RTL_DIR = rtl
TB_DIR = tb
IMG_DIR = img

ifeq ($(TEST),1)
  DESIGN = edge_detector
  KERNEL_SIZE = 3
endif
ifeq ($(TEST),2)
  DESIGN = edge_detector_locked
  KERNEL_SIZE = 3
endif
ifeq ($(TEST),3)
  DESIGN = blur
  KERNEL_SIZE = 4
endif
ifeq ($(TEST),4)
  DESIGN = blur_locked
  KERNEL_SIZE = 4
endif

ifeq ($(DESIGN),)
$(error Invalid TEST number: $(TEST). Use TEST=1|2|3|4)
endif

all: clean run

run:
 # source venv/bin/activate
	@echo "Running TEST $(TEST): $(DESIGN)"
	python3 png2hex.py $(KERNEL_SIZE)
	iverilog -o sim $(RTL_DIR)/$(DESIGN).v $(TB_DIR)/tb_$(DESIGN).v
	vvp sim
	python3 hex2png.py 
	
clean:
	rm -rf sim dump.vcd $(IMG_DIR)/output* $(IMG_DIR)/input.hex obj_dir

