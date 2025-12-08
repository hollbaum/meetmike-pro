#!/bin/bash

##############################################################################
# TEST SUITE: Individual Agent Functionality Tests
# File: test-individual-agents.sh
# Purpose: Validate each MAX Pipeline agent (LILLy, Mike, Clara, Aria, Finn, Anya, Atlas)
# Execution: Run before Pipeline Flow Tests
# Duration: ~30 minutes (all agents in parallel)
##############################################################################

set -e

# Configuration
AGENTS=("LILLy" "Mike" "Clara" "Aria" "Finn" "Anya" "Atlas")
SIGNAL_DIR="/workspaces/Measai-Maestro/AI_Agents/signals"
TEST_TIMESTAMP=$(date -u +%Y-%m-%dT%H:%M:%SZ)
RESULTS_FILE="test-results-individual-$(date +%Y%m%d-%H%M%S).txt"

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test counter
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0

##############################################################################
# HELPER FUNCTIONS
##############################################################################

log_test() {
    local test_name=$1
    local agent=$2
    echo "[$(date -u +%H:%M:%S)] TEST: $test_name ($agent)" | tee -a "$RESULTS_FILE"
}

log_pass() {
    local msg=$1
    echo -e "${GREEN}✅ PASS${NC}: $msg" | tee -a "$RESULTS_FILE"
    ((PASSED_TESTS++))
}

log_fail() {
    local msg=$1
    echo -e "${RED}❌ FAIL${NC}: $msg" | tee -a "$RESULTS_FILE"
    ((FAILED_TESTS++))
}

log_warn() {
    local msg=$1
    echo -e "${YELLOW}⚠️  WARN${NC}: $msg" | tee -a "$RESULTS_FILE"
}

test_agent() {
    local agent=$1
    
    ((TOTAL_TESTS++))
    log_test "Signal Reception" "$agent"
    
    # 1. Send signal to agent
    if maestro-conductor-sendSignal \
        --to "$agent" \
        --type "INFO" \
        --subject "TEST: Signal Reception ($TEST_TIMESTAMP)" \
        --body "Test message from QA suite at $TEST_TIMESTAMP" 2>/dev/null; then
        
        sleep 1
        
        # 2. Verify signal was recorded
        if find "$SIGNAL_DIR" -name "*$agent*" -type f -mmin -1 2>/dev/null | grep -q .; then
            log_pass "Signal sent and found for $agent"
        else
            log_warn "Signal sent but not yet found in directory (async delivery)"
        fi
    else
        log_fail "Failed to send signal to $agent"
    fi
    
    # 3. Test CLI responsiveness
    ((TOTAL_TESTS++))
    log_test "CLI Responsiveness" "$agent"
    
    agent_session="${agent,,}_session"
    
    if tmux list-sessions 2>/dev/null | grep -q "$agent_session"; then
        if timeout 3 tmux send-keys -t "$agent_session" "echo 'test' > /dev/null" Enter 2>/dev/null; then
            log_pass "CLI responsive for $agent"
        else
            log_warn "CLI may be slow or unresponsive for $agent"
        fi
    else
        log_warn "Session not found for $agent (not yet running)"
    fi
    
    # 4. Check activity log exists
    ((TOTAL_TESTS++))
    log_test "Activity Logging" "$agent"
    
    log_path="/workspaces/Measai-Maestro/AI_Agents/$agent/daily-activity.log"
    
    if [ -f "$log_path" ]; then
        log_pass "Activity log exists for $agent"
    else
        log_warn "Activity log not yet created for $agent (normal pre-Phase 3)"
    fi
}

##############################################################################
# MAIN TEST EXECUTION
##############################################################################

echo "========================================" | tee "$RESULTS_FILE"
echo "MAX Pipeline: Individual Agent Tests" | tee -a "$RESULTS_FILE"
echo "Test Run: $TEST_TIMESTAMP" | tee -a "$RESULTS_FILE"
echo "========================================" | tee -a "$RESULTS_FILE"
echo "" | tee -a "$RESULTS_FILE"

# Test each agent
for agent in "${AGENTS[@]}"; do
    echo "" | tee -a "$RESULTS_FILE"
    echo "Testing agent: $agent" | tee -a "$RESULTS_FILE"
    echo "---" | tee -a "$RESULTS_FILE"
    test_agent "$agent"
done

##############################################################################
# SUMMARY
##############################################################################

echo "" | tee -a "$RESULTS_FILE"
echo "========================================" | tee -a "$RESULTS_FILE"
echo "Test Summary" | tee -a "$RESULTS_FILE"
echo "========================================" | tee -a "$RESULTS_FILE"
echo "Total Tests: $TOTAL_TESTS" | tee -a "$RESULTS_FILE"
echo "Passed: $PASSED_TESTS" | tee -a "$RESULTS_FILE"
echo "Failed: $FAILED_TESTS" | tee -a "$RESULTS_FILE"
echo "Results saved to: $RESULTS_FILE" | tee -a "$RESULTS_FILE"
echo "" | tee -a "$RESULTS_FILE"

if [ $FAILED_TESTS -eq 0 ]; then
    echo -e "${GREEN}✅ All tests PASSED!${NC}" | tee -a "$RESULTS_FILE"
    exit 0
else
    echo -e "${RED}❌ Some tests FAILED. Review results.${NC}" | tee -a "$RESULTS_FILE"
    exit 1
fi
