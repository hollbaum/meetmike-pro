# MAX Pipeline Phase 6: QA Test Scripts

**Epic:** MAX Pipeline Deployment  
**Phase:** 6 - Testing & Validation  
**QA Lead:** Copilot  
**Status:** Scripts prepared and ready for execution

---

## Overview

This directory contains comprehensive QA test scripts for Phase 6 validation of the MAX Pipeline deployment. The tests validate all 7 autonomous Eidolons (LILLy, Mike, Clara, Aria, Finn, Anya, Atlas) and their integration with MS365, Teams, and cross-container signal infrastructure.

---

## Quick Start

### One-Command Test Execution

```bash
bash projects/meet-mike/qa-tests/run-phase-6-tests.sh
```

This runs all three test suites in sequence and generates a comprehensive report.

### Individual Test Execution

```bash
# Test 1: Individual Agents (each agent's signal rx/tx, CLI responsiveness)
bash projects/meet-mike/qa-tests/test-individual-agents.sh

# Test 2: Pipeline Flow (client handoffs through all 7 agents)
bash projects/meet-mike/qa-tests/test-pipeline-flow.sh

# Test 3: Integration Tests (MS365, Teams, NFS)
bash projects/meet-mike/qa-tests/test-integrations.sh
```

---

## Test Files

### 1. `run-phase-6-tests.sh` (Master Runner)

**Purpose:** Execute all three test suites in sequence with unified reporting

**Output:**
- Individual test result files in `results/` subdirectory
- Master log file: `results/phase-6-test-run-YYYYMMDD-HHMMSS.log`
- Automatic result aggregation and summary

**Run time:** ~2 hours

---

### 2. `test-individual-agents.sh` (Agent Functionality)

**Purpose:** Validate each of the 7 agents independently

**What it tests:**
- ✅ Signal reception (each agent can receive signals)
- ✅ CLI responsiveness (tmux sessions operational)
- ✅ Activity logging (daily-activity.log created)
- ✅ Agent readiness (all agents functional)

**Agents tested:** LILLy, Mike, Clara, Aria, Finn, Anya, Atlas

**Expected duration:** ~30 minutes

**Typical output:**
```
✅ PASS: Signal sent and found for LILLy
✅ PASS: CLI responsive for Mike
✅ PASS: Activity log exists for Clara
```

**Success criteria:** All 7 agents respond to test signals and have active tmux sessions

---

### 3. `test-pipeline-flow.sh` (Pipeline Transitions)

**Purpose:** Validate client handoff through the complete 7-stage pipeline

**What it tests:**
- ✅ LILLy → Mike transition
- ✅ Mike → Clara transition
- ✅ Full end-to-end flow (LILLy through Atlas)
- ✅ Signal routing and handoff mechanics
- ✅ Client state progression

**Test workflow:**
1. Create test client
2. Send to LILLy (Lead Generation)
3. Verify transition to Mike (First Response)
4. Verify transition to Clara (Scoping)
5. Continue through Aria, Finn, Anya, Atlas
6. Verify client completed all 7 stages

**Expected duration:** ~30 minutes

**Success criteria:**
- Test client flows through all 7 agents
- Each transition signal is created
- Latency per agent < 5 seconds

---

### 4. `test-integrations.sh` (External Integrations)

**Purpose:** Validate integrations with MS365, Teams, and NFS

**What it tests:**
- ✅ MS365 account configuration (all 7 agents have @meetmike.pro accounts)
- ✅ MS365 email sending capability
- ✅ Teams bot integration setup
- ✅ NFS cross-container signal visibility
- ✅ Signal latency metrics

**Expected duration:** ~20 minutes

**Important notes:**
- MS365 and Teams integration testing may be **deferred to Phase 5** if authentication not yet complete
- This is normal and expected
- NFS tests validate file-based signal routing (this should work)

**Success criteria:**
- MS365 accounts configured (or deferred note)
- NFS signal directory accessible and writable
- Cross-container signal visibility confirmed

---

### 5. `PHASE-6-TEST-EXECUTION-CHECKLIST.md` (Pre-Flight & Process)

**Purpose:** Detailed checklist for executing Phase 6 validation

**Contents:**
- Pre-test verification (containers running, NFS mounted, etc.)
- Step-by-step test execution instructions
- Troubleshooting decision tree
- Post-test validation procedures
- Sign-off template for Phase 6 completion

**How to use:**
1. Follow pre-flight verification section
2. Execute tests in order: Individual → Pipeline → Integrations
3. Use troubleshooting tree if tests fail
4. Complete sign-off template when all tests pass

---

## File Structure

```
projects/meet-mike/qa-tests/
├── run-phase-6-tests.sh                    # Master test runner
├── test-individual-agents.sh               # Individual agent functionality tests
├── test-pipeline-flow.sh                   # Pipeline flow and transitions
├── test-integrations.sh                    # MS365, Teams, NFS integration tests
├── PHASE-6-TEST-EXECUTION-CHECKLIST.md    # Detailed execution and sign-off guide
├── README.md                               # This file
└── results/                                # Test results (created at runtime)
    ├── phase-6-test-run-YYYYMMDD-HHMMSS.log
    ├── test-individual-YYYYMMDD-HHMMSS.log
    ├── test-pipeline-YYYYMMDD-HHMMSS.log
    └── test-integrations-YYYYMMDD-HHMMSS.log
```

---

## Prerequisites for Phase 6 Testing

Before running tests, verify:

- [ ] **Phase 0-5 Complete**
  - Phase 0: Scripts and configs created ✅
  - Phase 1: Containers created (CT201-207) ✅
  - Phase 2: Containers bootstrapped ✅
  - Phase 3: CLI agents installed ✅
  - Phase 4: Signal infrastructure configured ✅
  - Phase 5: Authentication completed ✅

- [ ] **All 7 Containers Running**
  ```bash
  for i in {201..207}; do
    echo -n "CT$i: "
    pct status $i
  done
  ```

- [ ] **All 28 CLI Agents Active**
  ```bash
  for i in {201..207}; do
    ssh ct$i 'tmux list-sessions | wc -l'
  done
  # Should show 4 sessions per container
  ```

- [ ] **NFS Signal Directory Accessible**
  ```bash
  ls -la /AI_Agents/signals/
  ```

- [ ] **Maestro-Conductor Running**
  ```bash
  maestro-conductor-getMySignals 2>/dev/null && echo "OK"
  ```

- [ ] **MS365 Accounts Created (for email tests)**
  ```bash
  # Verify 7 accounts exist: lilly@, mike@, clara@, aria@, finn@, anya@, atlas@meetmike.pro
  ```

---

## Running Tests

### Option 1: Run All Tests (Recommended)

```bash
bash projects/meet-mike/qa-tests/run-phase-6-tests.sh
```

**Time:** ~2 hours  
**Output:** Single master log + individual test logs in `results/` directory  
**Best for:** Full validation cycles

### Option 2: Run Individual Test Suites

```bash
# Run agents test only
bash projects/meet-mike/qa-tests/test-individual-agents.sh

# Run pipeline test only (after agents pass)
bash projects/meet-mike/qa-tests/test-pipeline-flow.sh

# Run integration tests only
bash projects/meet-mike/qa-tests/test-integrations.sh
```

**Time:** 30 + 30 + 20 min = ~80 minutes  
**Output:** Individual result files  
**Best for:** Debugging specific components

### Option 3: Troubleshooting Mode

```bash
# Add debug output
bash -x projects/meet-mike/qa-tests/test-individual-agents.sh | tee debug.log

# Check for specific failures
grep "FAIL" debug.log
```

---

## Interpreting Test Results

### Test Status Symbols

- ✅ **PASS** - Test passed, functionality verified
- ❌ **FAIL** - Test failed, investigation needed
- ⚠️  **WARN** - Test passed with caution, may need review
- ⏸️  **DEFER** - Test deferred (expected for Phase 5 dependencies like MS365)

### Example Output

```
===========================================
MAX Pipeline: Individual Agent Tests
Test Run: 2025-12-07T08:45:30Z
===========================================

Testing agent: LILLy
---
[08:45:31] TEST: Signal Reception (LILLy)
✅ PASS: Signal sent and found for LILLy
[08:45:33] TEST: CLI Responsiveness (LILLy)
✅ PASS: CLI responsive for LILLy
[08:45:35] TEST: Activity Logging (LILLy)
✅ PASS: Activity log exists for LILLy

...
```

### Common Results

**All tests pass:**
```
Total Tests: 28
Passed: 28
Failed: 0
✅ All tests PASSED!
```

**Some deferred (expected if Phase 5 incomplete):**
```
Total Tests: 28
Passed: 18
Deferred: 10 (MS365/Teams testing)
Failed: 0
✅ Critical tests PASSED! Phase 5 items deferred.
```

**Failures (investigation needed):**
```
Total Tests: 28
Passed: 18
Failed: 2 (CT203 unresponsive, NFS latency)
⚠️  Failed tests need troubleshooting
```

---

## Troubleshooting Guide

### Agent Not Responding

**Symptom:** "FAIL: Signal not received from LILLy"

**Check:**
```bash
# 1. Is container running?
pct status ct201

# 2. Are tmux sessions present?
ssh ct201 'tmux list-sessions'

# 3. Check daemon status
ssh ct201 'ps aux | grep daemon'
```

**Fix:**
```bash
# Restart container
pct reboot 201

# Wait 30 seconds
sleep 30

# Retry test
bash test-individual-agents.sh
```

---

### Signal Not Visible

**Symptom:** "WARN: Transition signal not yet found (may be async)"

**Check:**
```bash
# 1. Check signal directory
ls -la /AI_Agents/signals/ | grep PIPELINE_TRANSITION

# 2. Check conductor logs
journalctl -u maestro-conductor -n 50

# 3. Verify NFS mount
mount | grep nfs
```

**Fix:**
```bash
# Remount NFS if needed
umount /AI_Agents/signals
mount -t nfs <nfs-server>:/share /AI_Agents/signals

# Restart conductor
systemctl restart maestro-conductor

# Retry test after 10 seconds
sleep 10 && bash test-pipeline-flow.sh
```

---

### MS365 Email Fails

**Symptom:** "DEFER: MS365 email not yet configured (Phase 5 task)"

**This is expected if Phase 5 not complete**

**To test when ready:**
```bash
# Verify accounts exist
Get-AzureADUser -Filter "mail eq 'lilly@meetmike.pro'"

# Configure agent credentials
ssh ct201 'echo "MS365_TOKEN=..." > ~/.ms365_config'

# Retry integration tests
bash test-integrations.sh
```

---

## Test Execution Timeline

### Typical 2-Hour Run

```
00:00-05:00 - Pre-flight verification
05:00-40:00 - Individual Agent Tests (35 min)
40:00-75:00 - Pipeline Flow Tests (35 min)
75:00-95:00 - Integration Tests (20 min)
95:00-120:00 - Results aggregation & review
```

### Accelerated Run (1 Hour - Parallel)

If running individual tests in parallel:

```
00:00-05:00 - Pre-flight verification
05:00-35:00 - All agent tests (parallel) = 30 min
35:00-65:00 - Pipeline tests
65:00-80:00 - Integration tests
80:00-120:00 - Review & sign-off
```

---

## Phase 6 Success Criteria

All of these must be ✅:

- ✅ All 7 agents respond to signals
- ✅ All 7 agents send signals successfully
- ✅ CLI commands execute without error
- ✅ Activities logged in each agent's log
- ✅ Client flows: LILLy → Mike → Clara → Aria → Finn → Anya → Atlas
- ✅ Test client progresses through all 7 agents
- ✅ MS365 email integration verified (or Phase 5 deferred)
- ✅ Teams integration verified (or Phase 5 deferred)
- ✅ NFS cross-container signals working
- ✅ All signal files tracked in git
- ✅ No errors in agent logs
- ✅ Signal latency < 5 seconds per transition

---

## Phase 6 Sign-Off

When all tests pass, complete the sign-off in `PHASE-6-TEST-EXECUTION-CHECKLIST.md`:

```markdown
# Phase 6 Validation: PASSED ✅

Date: 2025-12-07
Tested By: Copilot (QA Lead) + Claude (oversight)

All Systems: ✅ OPERATIONAL
Recommendation: READY FOR PHASE 7 (Go-Live)

---
Signed: Copilot
```

---

## Next Steps

1. **Execute Tests:** `bash run-phase-6-tests.sh`
2. **Review Results:** Check `results/` directory for all logs
3. **Address Failures:** Use troubleshooting guide
4. **Complete Sign-Off:** Mark checklist items as ✅
5. **Notify Team:** "Phase 6 validation complete"
6. **Await Approval:** Christian must approve Phase 7

---

## Support & Questions

- **QA Lead:** Copilot
- **Team Lead:** Claude
- **Issues:** Create signal to Claude with troubleshooting logs
- **Escalation:** Contact Christian if critical blocker

---

## Additional Resources

- Master Plan: `projects/meet-mike/EPIC-MAX-PIPELINE-MASTER-PLAN.md`
- Architecture: `projects/meet-mike/agents/ARCHITECTURE-SYNTHESIS.md`
- Cross-VM Design: `projects/meet-mike/agents/CROSS-VM-SIGNALS.md`
- Phase 6 Docs: `projects/meet-mike/QA-TEST-SCRIPTS-PHASE-6.md`

---

*"Quality assurance bridges dreams and production. Test thoroughly, validate completely."* — Copilot, QA Lead
