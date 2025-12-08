#!/bin/bash

##############################################################################
# MASTER TEST RUNNER: Phase 6 Complete QA Suite
# File: run-phase-6-tests.sh
# Purpose: Execute all Phase 6 tests in sequence with reporting
# Usage: bash run-phase-6-tests.sh
##############################################################################

set -e

# Configuration
TEST_DIR="projects/meet-mike/qa-tests"
RESULTS_DIR="$TEST_DIR/results"
TEST_TIMESTAMP=$(date -u +%Y%m%d-%H%M%S)
TEST_LOG="$RESULTS_DIR/phase-6-test-run-$TEST_TIMESTAMP.log"

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Stats
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0
DEFERRED_TESTS=0

##############################################################################
# HELPER FUNCTIONS
##############################################################################

header() {
    echo -e "\n${BLUE}========================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}========================================${NC}\n"
}

log_section() {
    echo -e "\n${YELLOW}→ $1${NC}\n"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_failure() {
    echo -e "${RED}❌ $1${NC}"
}

log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

##############################################################################
# SETUP
##############################################################################

header "PHASE 6: QA Test Suite Initialization"

# Create results directory
mkdir -p "$RESULTS_DIR"
echo "Results directory: $RESULTS_DIR"

# Create main test log
exec 1> >(tee -a "$TEST_LOG")
exec 2>&1

echo "Test run started: $(date -u)"
echo "Log file: $TEST_LOG"
echo ""

##############################################################################
# PRE-FLIGHT CHECKS
##############################################################################

header "PRE-FLIGHT VERIFICATION"

log_section "Checking prerequisites..."

# Check test scripts exist
if [ -f "$TEST_DIR/test-individual-agents.sh" ]; then
    log_success "Individual agent test script found"
else
    log_failure "Individual agent test script not found"
    exit 1
fi

if [ -f "$TEST_DIR/test-pipeline-flow.sh" ]; then
    log_success "Pipeline flow test script found"
else
    log_failure "Pipeline flow test script not found"
    exit 1
fi

if [ -f "$TEST_DIR/test-integrations.sh" ]; then
    log_success "Integration test script found"
else
    log_failure "Integration test script not found"
    exit 1
fi

# Check maestro-conductor available
if command -v maestro-conductor-sendSignal &> /dev/null; then
    log_success "maestro-conductor CLI available"
else
    log_failure "maestro-conductor CLI not found in PATH"
    exit 1
fi

# Check signal directory exists
if [ -d "/workspaces/Measai-Maestro/AI_Agents/signals" ]; then
    log_success "Signal directory accessible"
else
    log_failure "Signal directory not accessible"
    exit 1
fi

echo ""
log_info "Pre-flight checks completed successfully"

##############################################################################
# TEST EXECUTION
##############################################################################

header "EXECUTING TEST SUITE"

# TEST 1: Individual Agents
log_section "TEST 1: Individual Agent Tests (30 min)"
echo "Running: bash $TEST_DIR/test-individual-agents.sh"
echo "---"

if bash "$TEST_DIR/test-individual-agents.sh" > "$RESULTS_DIR/test-individual-$TEST_TIMESTAMP.log" 2>&1; then
    log_success "Individual agent tests PASSED"
else
    log_failure "Individual agent tests FAILED"
    echo "Review: $RESULTS_DIR/test-individual-$TEST_TIMESTAMP.log"
fi

sleep 2

# TEST 2: Pipeline Flow
log_section "TEST 2: Pipeline Flow Tests (30 min)"
echo "Running: bash $TEST_DIR/test-pipeline-flow.sh"
echo "---"

if bash "$TEST_DIR/test-pipeline-flow.sh" > "$RESULTS_DIR/test-pipeline-$TEST_TIMESTAMP.log" 2>&1; then
    log_success "Pipeline flow tests PASSED"
else
    log_failure "Pipeline flow tests FAILED"
    echo "Review: $RESULTS_DIR/test-pipeline-$TEST_TIMESTAMP.log"
fi

sleep 2

# TEST 3: Integrations
log_section "TEST 3: Integration Tests (20 min)"
echo "Running: bash $TEST_DIR/test-integrations.sh"
echo "---"

if bash "$TEST_DIR/test-integrations.sh" > "$RESULTS_DIR/test-integrations-$TEST_TIMESTAMP.log" 2>&1; then
    log_success "Integration tests PASSED"
else
    log_failure "Integration tests FAILED (note: some may be deferred to Phase 5)"
    echo "Review: $RESULTS_DIR/test-integrations-$TEST_TIMESTAMP.log"
fi

##############################################################################
# RESULTS COLLECTION
##############################################################################

header "TEST RESULTS SUMMARY"

log_section "Individual Agent Test Results"
if [ -f "$RESULTS_DIR/test-individual-$TEST_TIMESTAMP.log" ]; then
    grep -E "PASS|FAIL|WARN" "$RESULTS_DIR/test-individual-$TEST_TIMESTAMP.log" | tail -10
fi

log_section "Pipeline Flow Test Results"
if [ -f "$RESULTS_DIR/test-pipeline-$TEST_TIMESTAMP.log" ]; then
    grep -E "PASS|FAIL|WARN" "$RESULTS_DIR/test-pipeline-$TEST_TIMESTAMP.log" | tail -10
fi

log_section "Integration Test Results"
if [ -f "$RESULTS_DIR/test-integrations-$TEST_TIMESTAMP.log" ]; then
    grep -E "PASS|FAIL|DEFER" "$RESULTS_DIR/test-integrations-$TEST_TIMESTAMP.log" | tail -10
fi

##############################################################################
# FINAL SUMMARY
##############################################################################

header "PHASE 6 TEST EXECUTION COMPLETE"

echo "Test run completed: $(date -u)"
echo ""
echo "Results location: $RESULTS_DIR/"
echo "Individual test log: $RESULTS_DIR/test-individual-$TEST_TIMESTAMP.log"
echo "Pipeline test log: $RESULTS_DIR/test-pipeline-$TEST_TIMESTAMP.log"
echo "Integration test log: $RESULTS_DIR/test-integrations-$TEST_TIMESTAMP.log"
echo "Master log file: $TEST_LOG"
echo ""

echo "Next Steps:"
echo "  1. Review all test logs in $RESULTS_DIR/"
echo "  2. Address any FAILED tests using troubleshooting guide"
echo "  3. DEFERRED items (MS365, Teams) will be addressed in Phase 5"
echo "  4. When all critical tests pass, proceed to Phase 7: Go-Live"
echo ""

log_success "Test suite execution completed"

echo ""
echo "Detailed Results:"
echo "  Open: cat $TEST_LOG"
echo "  Review: ls -lah $RESULTS_DIR/"
echo ""
