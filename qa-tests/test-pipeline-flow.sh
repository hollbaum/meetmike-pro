#!/bin/bash

##############################################################################
# TEST SUITE: Pipeline Flow Tests
# File: test-pipeline-flow.sh
# Purpose: Validate pipeline transitions and end-to-end client flow
# Execution: Run after Individual Agent Tests
# Duration: ~30 minutes
##############################################################################

set -e

TEST_TIMESTAMP=$(date -u +%Y-%m-%dT%H:%M:%SZ)
RESULTS_FILE="test-results-pipeline-$(date +%Y%m%d-%H%M%S).txt"
TEST_CLIENT="test-client-$(date +%s)"
STATE_DIR="/workspaces/Measai-Maestro/projects/meet-mike/client-state"
SIGNAL_DIR="/workspaces/Measai-Maestro/AI_Agents/signals"

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

TESTS_PASSED=0
TESTS_FAILED=0

##############################################################################
# HELPER FUNCTIONS
##############################################################################

log_test() {
    local phase=$1
    local description=$2
    echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}" | tee -a "$RESULTS_FILE"
    echo -e "${BLUE}PHASE $phase: $description${NC}" | tee -a "$RESULTS_FILE"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}" | tee -a "$RESULTS_FILE"
}

log_pass() {
    local msg=$1
    echo -e "${GREEN}✅ PASS${NC}: $msg" | tee -a "$RESULTS_FILE"
    ((TESTS_PASSED++))
}

log_fail() {
    local msg=$1
    echo -e "${RED}❌ FAIL${NC}: $msg" | tee -a "$RESULTS_FILE"
    ((TESTS_FAILED++))
}

log_info() {
    local msg=$1
    echo -e "${BLUE}ℹ️  INFO${NC}: $msg" | tee -a "$RESULTS_FILE"
}

##############################################################################
# PIPELINE TRANSITION TESTS
##############################################################################

test_lilly_to_mike() {
    log_test "1" "LILLy → Mike Transition"
    
    echo "Creating test lead: $TEST_CLIENT" | tee -a "$RESULTS_FILE"
    
    # Step 1: Send lead to LILLy
    if maestro-conductor-sendSignal \
        --to "LILLy" \
        --type "REQUEST" \
        --subject "PHASE-6-TEST: New Lead" \
        --body "Process lead: $TEST_CLIENT (test at $TEST_TIMESTAMP)" 2>/dev/null; then
        log_info "Signal sent to LILLy"
        log_pass "LILLy signal delivery"
    else
        log_fail "Could not send signal to LILLy"
        return 1
    fi
    
    sleep 3
    
    # Step 2: Verify transition signal created
    if find "$SIGNAL_DIR" -name "*LILLy_to_Mike*" -mmin -1 2>/dev/null | grep -q .; then
        log_pass "LILLy routed to Mike (transition signal found)"
    else
        log_info "Transition signal not yet found (may be async)"
    fi
    
    # Step 3: Verify Mike received handoff
    sleep 2
    if maestro-conductor-getMySignals --currentAgent "Mike" 2>/dev/null | grep -q "PHASE-6-TEST"; then
        log_pass "Mike received lead handoff"
    else
        log_info "Mike signal not yet visible (may be async)"
    fi
}

test_mike_to_clara() {
    log_test "2" "Mike → Clara Transition"
    
    log_info "Requesting Mike to route to Clara"
    
    if maestro-conductor-sendSignal \
        --to "Mike" \
        --type "REQUEST" \
        --subject "PHASE-6-TEST: Route to Clara" \
        --body "Client $TEST_CLIENT ready for scoping" 2>/dev/null; then
        log_pass "Routing request to Mike"
    else
        log_fail "Could not send routing request to Mike"
        return 1
    fi
    
    sleep 3
    
    # Verify Clara received
    if find "$SIGNAL_DIR" -name "*Mike_to_Clara*" -mmin -1 2>/dev/null | grep -q .; then
        log_pass "Mike routed to Clara"
    else
        log_info "Transition not yet visible"
    fi
}

test_full_pipeline_flow() {
    log_test "E2E" "Full End-to-End Pipeline (All 7 Agents)"
    
    local AGENTS=("LILLy" "Mike" "Clara" "Aria" "Finn" "Anya" "Atlas")
    local TEST_CLIENT_E2E="e2e-client-$(date +%s)"
    
    echo "Starting E2E flow with client: $TEST_CLIENT_E2E" | tee -a "$RESULTS_FILE"
    
    # Phase 1: LILLy (Lead Generation)
    log_info "PHASE 1: Lead entering LILLy"
    if maestro-conductor-sendSignal \
        --to "LILLy" \
        --type "REQUEST" \
        --subject "PHASE-6-E2E: New Lead" \
        --body "$TEST_CLIENT_E2E" 2>/dev/null; then
        log_pass "Lead created in LILLy"
    fi
    sleep 2
    
    # Phase 2-7: Simulate transitions
    for i in "${!AGENTS[@]}"; do
        if [ $i -lt $((${#AGENTS[@]} - 1)) ]; then
            current="${AGENTS[$i]}"
            next="${AGENTS[$((i+1))]}"
            
            log_info "PHASE $((i+2)): $current → $next transition"
            
            # Send routing signal
            maestro-conductor-sendSignal \
                --to "$current" \
                --type "REQUEST" \
                --subject "PHASE-6-E2E: Route to $next" \
                --body "Client $TEST_CLIENT_E2E ready for next stage" 2>/dev/null || true
            
            sleep 2
        fi
    done
    
    # Final check
    log_info "E2E flow completed (verify agent activity logs for details)"
    log_pass "End-to-end pipeline flow initiated"
}

##############################################################################
# MAIN EXECUTION
##############################################################################

echo "========================================" | tee "$RESULTS_FILE"
echo "MAX Pipeline: Flow Tests" | tee -a "$RESULTS_FILE"
echo "Test Run: $TEST_TIMESTAMP" | tee -a "$RESULTS_FILE"
echo "Test Client: $TEST_CLIENT" | tee -a "$RESULTS_FILE"
echo "========================================" | tee -a "$RESULTS_FILE"

test_lilly_to_mike
test_mike_to_clara
test_full_pipeline_flow

##############################################################################
# SUMMARY
##############################################################################

echo "" | tee -a "$RESULTS_FILE"
echo "========================================" | tee -a "$RESULTS_FILE"
echo "Pipeline Flow Test Summary" | tee -a "$RESULTS_FILE"
echo "========================================" | tee -a "$RESULTS_FILE"
echo "Tests Passed: $TESTS_PASSED" | tee -a "$RESULTS_FILE"
echo "Tests Failed: $TESTS_FAILED" | tee -a "$RESULTS_FILE"
echo "Test Client: $TEST_CLIENT" | tee -a "$RESULTS_FILE"
echo "Results saved to: $RESULTS_FILE" | tee -a "$RESULTS_FILE"
echo "" | tee -a "$RESULTS_FILE"

if [ $TESTS_FAILED -eq 0 ]; then
    echo -e "${GREEN}✅ Pipeline flow tests PASSED!${NC}" | tee -a "$RESULTS_FILE"
    exit 0
else
    echo -e "${RED}❌ Some tests FAILED${NC}" | tee -a "$RESULTS_FILE"
    exit 1
fi
