#
#  Makefile
#  Simple GNU Makefile to build and install the project
#
#  Copyright 2023 Leaf Software Foundation
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#

PROJECT_NAME := Scratch a Pixel 3D Renderer
PROJECT_VERSION := 0.1.2.3-dev
# VERSION in the form MAJOR.MINOR.PATCH.BUILD-AUDIENCE
# Example for Developer Build, version 2.14 patch 3
# 2.14.3.841-dev
# Example for Stable Release, version 2.15 patch 0
# 2.15.0.857


# Important Directories
BUILD_DIR  := ./build
SOURCE_DIR := ./source
DESTDIR    := $(BUILD_DIR)/install

INCLUDE_DIR := $(SOURCE_DIR)/include
LIBRARY_DIR := $(SOURCE_DIR)/lib



# Compiler and Linker Options
CC := gcc
LD := gcc

INCLUDE_FLAGS := -I$(INCLUDE_DIR) -I$(SOURCE_DIR)
LIBRARY_FLAGS := -L$(LIBRARY_DIR) -L$(BUILD_DIR)

DEFAULT_C_FLAGS := $(INCLUDE_FLAGS) -O3 -ansi -pedantic -Wpedantic -Wall -Werror
DEFAULT_LINKER_FLAGS := $(LIBRARY_FLAGS)


# Important Files
VEC_LIB := libvec.dll
VEC_SOURCE_FILENAMES := vec/vector.c
VEC_SOURCE_FILES := $(foreach filename,$(VEC_SOURCE_FILENAMES),$(SOURCE_DIR)/$(filename))
VEC_OBJECT_FILES := $(foreach filename,$(VEC_SOURCE_FILES),$(BUILD_DIR)/$(filename).o)
VEC_HEADER_FILENAMES := vec/vector.h
VEC_HEADER_FILES := $(foreach filename,$(VEC_HEADER_FILENAMES),$(SOURCE_DIR)/$(filename))
VEC_INSTALLED_HEADER_FILES := $(foreach filename,$(VECTOR_HEADER_FILENAMES),$(DEST_DIR)/share/include/$(filename))
VEC_C_FLAGS := -fPIC $(DEFAULT_C_FLAGS)
VEC_LINKER_FLAGS := $(DEFAULT_LINKER_FLAGS) -shared -lm

MAT_LIB := libmat.dll
MAT_SOURCE_FILENAMES := mat/matrix.c
MAT_SOURCE_FILES := $(foreach filename,$(MAT_SOURCE_FILENAMES),$(SOURCE_DIR)/$(filename))
MAT_OBJECT_FILES := $(foreach filename,$(MAT_SOURCE_FILES),$(BUILD_DIR)/$(filename).o)
MAT_HEADER_FILENAMES := mat/matrix.h
MAT_HEADER_FILES := $(foreach filename,$(MAT_HEADER_FILENAMES),$(SOURCE_DIR)/$(filename))
MAT_INSTALLED_HEADER_FILES := $(foreach filename,$(MAT_HEADER_FILENAMES),$(DEST_DIR)/share/include/$(filename))
MAT_C_FLAGS := -fPIC $(DEFAULT_C_FLAGS)
MAT_LINKER_FLAGS := $(DEFAULT_LINKER_FLAGS) -shared -lm -lvec

TEST_EXE := test.exe
TEST_SOURCE_FILENAMES := test/main.c
TEST_SOURCE_FILES := $(foreach filename,$(TEST_SOURCE_FILENAMES),$(SOURCE_DIR)/$(filename))
TEST_OBJECT_FILES := $(foreach filename,$(TEST_SOURCE_FILES),$(BUILD_DIR)/$(filename).o)
TEST_C_FLAGS := $(DEFAULT_C_FLAGS)
TEST_LINKER_FLAGS := $(DEFAULT_LINKER_FLAGS) -lm -lvec -lmat


# Build
.PHONY: build
build: $(BUILD_DIR)/$(TEST_EXE)

# libvec.dll
$(BUILD_DIR)/$(VEC_LIB): $(VEC_OBJECT_FILES)
	@mkdir -pv $(dir $@)
	$(LD) -o $@ $(VEC_LINKER_FLAGS) $(VEC_OBJECT_FILES)

$(BUILD_DIR)/$(SOURCE_DIR)/vec/%.c.o: $(SOURCE_DIR)/vec/%.c
	@mkdir -pv $(dir $@)
	$(CC) -c -o $@ $(VEC_C_FLAGS) $<


# libmat.dll
$(BUILD_DIR)/$(MAT_LIB): $(BUILD_DIR)/$(VEC_LIB) $(MAT_OBJECT_FILES)
	@mkdir -pv $(dir $@)
	$(LD) -o $@ $(MAT_LINKER_FLAGS) $(MAT_OBJECT_FILES)

$(BUILD_DIR)/$(SOURCE_DIR)/mat/%.c.o: $(SOURCE_DIR)/mat/%.c
	@mkdir -pv $(dir $@)
	$(CC) -c -o $@ $(MAT_C_FLAGS) $<


# test.exe
$(BUILD_DIR)/$(TEST_EXE): $(BUILD_DIR)/$(VEC_LIB) $(BUILD_DIR)/$(MAT_LIB) $(TEST_OBJECT_FILES)
	@mkdir -pv $(dir $@)
	$(LD) -o $@ $(TEST_LINKER_FLAGS) $(TEST_OBJECT_FILES)

$(BUILD_DIR)/$(SOURCE_DIR)/test/%.c.o: $(SOURCE_DIR)/test/%.c
	@mkdir -pv $(dir $@)
	$(CC) -c -o $@ $(TEST_C_FLAGS) $<


# Clean
.PHONY: clean
clean:
	@rm -rfv $(BUILD_DIR)


# Install
.PHONY: install
install: $(DESTDIR)/bin/$(TEST_EXE) $(DESTDIR)/lib/$(VEC_LIB) $(DESTDIR)/lib/$(MAT_LIB)


$(DESTDIR)/lib/$(VEC_LIB): $(BUILD_DIR)/$(VEC_LIB)
	@mkdir -pv $(dir $@)
	@cp -fv $< $@

$(DESTDIR)/lib/$(MAT_LIB): $(BUILD_DIR)/$(MAT_LIB)
	@mkdir -pv $(dir $@)
	@cp -fv $< $@

$(DESTDIR)/bin/$(TEST_EXE): $(BUILD_DIR)/$(TEST_EXE)
	@mkdir -pv $(dir $@)
	@cp -fv $< $@


# Uninstall
.PHONY: uninstall
uninstall:
	@rm -fv $(DESTDIR)/bin/$(TEST_EXE) 
	@rm -fv $(DESTDIR)/lib/$(VEC_LIB) 
	@rm -fv $(DESTDIR)/lib/$(MAT_LIB)


