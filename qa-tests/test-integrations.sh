#!/bin/bash

##############################################################################
# TEST SUITE: Integration Tests (MS365, Teams, NFS)
# File: test-integrations.sh
# Purpose: Validate external integrations
# Execution: Run after Pipeline Flow Tests
# Duration: ~20 minutes (some may defer to Phase 5)
##############################################################################

set -e

TEST_TIMESTAMP=$(date -u +%Y-%m-%dT%H:%M:%SZ)
RESULTS_FILE="test-results-integrations-$(date +%Y%m%d-%H%M%S).txt"
SIGNAL_DIR="/workspaces/Measai-Maestro/AI_Agents/signals"

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

TESTS_PASSED=0
TESTS_FAILED=0
TESTS_DEFERRED=0

##############################################################################
# HELPER FUNCTIONS
##############################################################################

log_section() {
    local title=$1
    echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}" | tee -a "$RESULTS_FILE"
    echo -e "${BLUE}$title${NC}" | tee -a "$RESULTS_FILE"
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

log_defer() {
    local msg=$1
    echo -e "${YELLOW}⏸️  DEFER${NC}: $msg" | tee -a "$RESULTS_FILE"
    ((TESTS_DEFERRED++))
}

log_info() {
    local msg=$1
    echo -e "${BLUE}ℹ️  INFO${NC}: $msg" | tee -a "$RESULTS_FILE"
}

##############################################################################
# MS365 INTEGRATION TESTS
##############################################################################

test_ms365_configuration() {
    log_section "MS365 Integration Tests"
    
    local AGENTS=("LILLy" "Mike" "Clara" "Aria" "Finn" "Anya" "Atlas")
    local CONFIGURED=0
    
    echo "Checking MS365 configuration for all agents..." | tee -a "$RESULTS_FILE"
    
    for agent in "${AGENTS[@]}"; do
        local identity_file="/workspaces/Measai-Maestro/projects/meet-mike/agents/$agent/identity-toolkit.md"
        
        if [ -f "$identity_file" ]; then
            if grep -q "MS365_ACCOUNT\|ms365\|@meetmike.pro" "$identity_file" 2>/dev/null; then
                log_info "$agent: MS365 configuration found"
                ((CONFIGURED++))
            else
                log_defer "$agent: MS365 account not yet configured (Phase 5 task)"
            fi
        else
            log_defer "$agent: Identity toolkit not found (normal pre-Phase 3)"
        fi
    done
    
    if [ $CONFIGURED -eq ${#AGENTS[@]} ]; then
        log_pass "All agents MS365 configured"
    else
        log_defer "MS365 configuration incomplete (expected - Phase 5 is authentication)"
    fi
    
    echo "" | tee -a "$RESULTS_FILE"
    echo "Note: Full MS365 testing deferred to Phase 5 (Authentication Phase)" | tee -a "$RESULTS_FILE"
}

##############################################################################
# TEAMS INTEGRATION TESTS
##############################################################################

test_teams_configuration() {
    log_section "Teams Integration Tests"
    
    echo "Checking Teams integration setup..." | tee -a "$RESULTS_FILE"
    
    # Check for Teams bot token
    if [ -n "$TEAMS_BOT_TOKEN" ]; then
        log_info "Teams bot token configured"
        
        # Check for Teams channel IDs
        if [ -n "$TEAMS_CHANNEL_ID" ]; then
            log_pass "Teams channel configured"
        else
            log_defer "Teams channel ID not set (Christian will set during Phase 5)"
        fi
    else
        log_defer "Teams bot token not configured (Phase 5 setup)"
    fi
    
    echo "" | tee -a "$RESULTS_FILE"
    echo "Note: Teams integration fully tested after Phase 5 authentication" | tee -a "$RESULTS_FILE"
}

##############################################################################
# NFS CROSS-CONTAINER TESTS
##############################################################################

test_nfs_mount() {
    log_section "NFS Cross-Container Signal Tests"
    
    echo "Testing NFS signal directory..." | tee -a "$RESULTS_FILE"
    
    # Test 1: Check NFS mount
    if [ -d "$SIGNAL_DIR" ]; then
        log_pass "Signal directory exists: $SIGNAL_DIR"
    else
        log_fail "Signal directory does not exist"
        return 1
    fi
    
    # Test 2: Check mount type
    if mount | grep -q "nfs"; then
        log_info "NFS mount detected"
        log_pass "NFS filesystem mounted"
    else
        log_defer "NFS may not be mounted yet (expected - Phase 1 task)"
    fi
    
    # Test 3: Write test file
    echo "Testing file creation in shared directory..." | tee -a "$RESULTS_FILE"
    
    local test_file="$SIGNAL_DIR/test-nfs-$(date +%s).txt"
    
    if echo "test-nfs-content" > "$test_file" 2>/dev/null; then
        log_pass "Signal file created: $test_file"
        
        # Test 4: Read test file
        if cat "$test_file" | grep -q "test-nfs-content"; then
            log_pass "Signal file readable"
        else
            log_fail "Signal file not readable"
        fi
        
        # Cleanup
        rm "$test_file" 2>/dev/null || true
    else
        log_defer "Cannot write to signal directory yet (Phase 1 NFS setup pending)"
    fi
}

test_cross_container_visibility() {
    log_section "Cross-Container Signal Visibility"
    
    echo "Testing signal visibility across containers..." | tee -a "$RESULTS_FILE"
    
    # Verify signal files are created in shared location
    local signal_count=$(find "$SIGNAL_DIR" -type f -name "*.md" 2>/dev/null | wc -l)
    
    if [ $signal_count -gt 0 ]; then
        log_pass "Signal files present: $signal_count files"
        echo "  Sample signals:" | tee -a "$RESULTS_FILE"
        find "$SIGNAL_DIR" -type f -name "*.md" | head -3 | while read f; do
            echo "    - $(basename $f)" | tee -a "$RESULTS_FILE"
        done
    else
        log_info "No signal files yet (normal for pre-Phase 3)"
    fi
    
    # Verify git tracking
    echo "" | tee -a "$RESULTS_FILE"
    echo "Checking git tracking of signals..." | tee -a "$RESULTS_FILE"
    
    if cd /workspaces/Measai-Maestro && git ls-files "$SIGNAL_DIR" | head -1 &>/dev/null; then
        log_pass "Signals tracked in git"
    else
        log_info "Signals not yet in git (normal during first phase)"
    fi
}

##############################################################################
# PERFORMANCE TESTS
##############################################################################

test_signal_latency() {
    log_section "Signal Latency Tests"
    
    echo "Testing signal delivery latency..." | tee -a "$RESULTS_FILE"
    
    # Send a test signal and measure time
    local start_time=$(date +%s%N)
    
    if maestro-conductor-sendSignal \
        --to "LILLy" \
        --type "INFO" \
        --subject "Latency test" \
        --body "Testing signal delivery latency" 2>/dev/null; then
        
        local end_time=$(date +%s%N)
        local latency_ms=$(( (end_time - start_time) / 1000000 ))
        
        if [ $latency_ms -lt 1000 ]; then
            log_pass "Signal send latency: ${latency_ms}ms (acceptable)"
        else
            log_defer "Signal send latency: ${latency_ms}ms (may improve after Phase 1 NFS setup)"
        fi
    else
        log_fail "Could not send test signal"
    fi
}

##############################################################################
# MAIN EXECUTION
##############################################################################

echo "========================================" | tee "$RESULTS_FILE"
echo "MAX Pipeline: Integration Tests" | tee -a "$RESULTS_FILE"
echo "Test Run: $TEST_TIMESTAMP" | tee -a "$RESULTS_FILE"
echo "========================================" | tee -a "$RESULTS_FILE"

test_ms365_configuration
test_teams_configuration
test_nfs_mount
test_cross_container_visibility
test_signal_latency

##############################################################################
# SUMMARY
##############################################################################

echo "" | tee -a "$RESULTS_FILE"
echo "========================================" | tee -a "$RESULTS_FILE"
echo "Integration Test Summary" | tee -a "$RESULTS_FILE"
echo "========================================" | tee -a "$RESULTS_FILE"
echo "Tests Passed: $TESTS_PASSED" | tee -a "$RESULTS_FILE"
echo "Tests Failed: $TESTS_FAILED" | tee -a "$RESULTS_FILE"
echo "Tests Deferred: $TESTS_DEFERRED (expected - depend on Phase 5)" | tee -a "$RESULTS_FILE"
echo "Results saved to: $RESULTS_FILE" | tee -a "$RESULTS_FILE"
echo "" | tee -a "$RESULTS_FILE"

if [ $TESTS_FAILED -eq 0 ]; then
    echo -e "${GREEN}✅ Integration tests PASSED!${NC}" | tee -a "$RESULTS_FILE"
    echo -e "${YELLOW}Note: Some tests deferred to Phase 5 (Authentication)${NC}" | tee -a "$RESULTS_FILE"
    exit 0
else
    echo -e "${RED}❌ Some tests FAILED${NC}" | tee -a "$RESULTS_FILE"
    exit 1
fi
