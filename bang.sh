#!/bin/bash

set -e

. env/bin/activate

uvicorn main:app --reload