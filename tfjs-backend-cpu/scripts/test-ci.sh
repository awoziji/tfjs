#!/usr/bin/env bash
# Copyright 2019 Google LLC. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# =============================================================================

set -e

yarn lint
yarn build

if [ "$NIGHTLY" = true ]
then
  # Run the first karma separately so it can download the BrowserStack binary
  # without conflicting with others.
  yarn run-browserstack --browsers=bs_safari_mac,bs_ios_11

  # Run the rest of the karma tests in parallel. These runs will reuse the
  # already downloaded binary.
  npm-run-all -p -c --aggregate-output \
    "run-browserstack --browsers=bs_android_9" \
    "run-browserstack --browsers=bs_firefox_mac,bs_chrome_mac" \
    "run-browserstack --browsers=win_10_chrome" \


  # Safari doesn't have offscreen canvas so use it to test cpu in a webworker.
  # yarn test-webworker --browsers=bs_safari_mac
else
  yarn run-browserstack --browsers=bs_chrome_mac
fi