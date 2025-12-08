# MAX Pipeline Phase 6: Test Execution Checklist

**Epic:** MAX Pipeline Deployment  
**Phase:** 6 - Testing & Validation  
**Date Prepared:** 2025-12-07  
**QA Lead:** Copilot  
**Estimated Duration:** 2-3 hours  
**Prerequisites:** Phases 0-5 complete (containers running, authentication done)

---

## Pre-Test Verification

- [ ] **All 7 Eidolon containers are running**
  - [ ] CT201 (LILLy) - running and accessible
  - [ ] CT202 (Mike) - running and accessible
  - [ ] CT203 (Clara) - running and accessible
  - [ ] CT204 (Aria) - running and accessible
  - [ ] CT205 (Finn) - running and accessible
  - [ ] CT206 (Anya) - running and accessible
  - [ ] CT207 (Atlas) - running and accessible

- [ ] **All 28 CLI agents are operational**
  - [ ] Verify: `for i in {201..207}; do ssh ct$i "tmux list-sessions" | head -4; done`
  - [ ] All tmux sessions present: claude_session, gemini_session, codex_session, copilot_session

- [ ] **NFS signal directory is mounted and accessible**
  - [ ] Check mount: `mount | grep nfs`
  - [ ] Verify: `ls -la /AI_Agents/signals/` accessible from all containers

- [ ] **Maestro-Conductor is running**
  - [ ] Verify: `ps aux | grep conductor`
  - [ ] Test: `maestro-conductor-getMySignals` returns results

- [ ] **MS365 accounts created and credentials configured**
  - [ ] 7 email accounts created (lilly@meetmike.pro, mike@, clara@, aria@, finn@, anya@, atlas@)
  - [ ] Credentials configured on each agent container
  - [ ] Test: `send_email test@example.com "Subject" "Body"` works from each agent

- [ ] **Test results directory exists**
  - [ ] Verify: `mkdir -p projects/meet-mike/qa-tests/results`
  - [ ] Ready to capture test output

---

## Test Execution Sequence

### STEP 1: Individual Agent Tests (~30 minutes)

**Purpose:** Validate each agent can receive signals, send signals, and respond to commands

**Executable:** `bash projects/meet-mike/qa-tests/test-individual-agents.sh`

**What this tests:**
- ✅ Signal reception on each agent
- ✅ CLI responsiveness
- ✅ Activity logging
- ✅ Basic agent functionality

**Expected outcome:**
- All 7 agents respond to test signals
- All agents have tmux sessions running
- Activity logs being created

**If test fails:**
- [ ] Check container is running: `ssh ct20x 'tmux list-sessions'`
- [ ] Verify NFS mount: `mount | grep /AI_Agents`
- [ ] Restart conductor: `systemctl restart maestro-conductor`
- [ ] Retry test after 10 seconds

**Document result:**
- [ ] All agents respond: ✅ / ⚠️  / ❌
- [ ] CLI responsive: ✅ / ⚠️  / ❌
- [ ] Logs being created: ✅ / ⚠️  / ❌

---

### STEP 2: Pipeline Flow Tests (~30 minutes)

**Purpose:** Validate client handoff between agents (core pipeline logic)

**Executable:** `bash projects/meet-mike/qa-tests/test-pipeline-flow.sh`

**What this tests:**
- ✅ LILLy → Mike transition
- ✅ Mike → Clara transition
- ✅ Full 7-agent end-to-end flow
- ✅ Signal routing through pipeline

**Expected outcome:**
- Test client flows from LILLy through all 7 agents
- Each transition signal is created
- Client state progresses through pipeline
- <5 second latency per agent transition

**If test fails:**
- [ ] Check signal directory: `ls -la /AI_Agents/signals/ | tail -20`
- [ ] Verify agent is receiving: `maestro-conductor-getMySignals --currentAgent LILLy`
- [ ] Check agent logs: `tail -20 /opt/maestro/AI_Agents/LILLy/daily-activity.log`
- [ ] Retry with debug: `bash -x test-pipeline-flow.sh`

**Document result:**
- [ ] LILLy → Mike: ✅ / ⚠️  / ❌
- [ ] Full E2E flow: ✅ / ⚠️  / ❌
- [ ] Signal routing: ✅ / ⚠️  / ❌
- [ ] Latency acceptable: ✅ / ⚠️  / ❌

---

### STEP 3: Integration Tests (~20 minutes)

**Purpose:** Validate external integrations (MS365, Teams, NFS)

**Executable:** `bash projects/meet-mike/qa-tests/test-integrations.sh`

**What this tests:**
- ✅ MS365 account configuration
- ✅ Teams integration setup
- ✅ NFS cross-container signal visibility
- ✅ Signal latency metrics

**Expected outcome:**
- All agents have MS365 accounts configured
- NFS signals visible across containers
- Teams integration ready
- Signal latency < 1 second

**If test fails:**
- [ ] MS365: Verify accounts exist in admin.microsoft.com
- [ ] Teams: Check Teams bot token in environment
- [ ] NFS: Verify mount on all containers
- [ ] Contact Christian if Teams channel not configured

**Document result:**
- [ ] MS365 configured: ✅ / ⚠️  / ❌ (defer if needed)
- [ ] Teams configured: ✅ / ⚠️  / ❌ (defer if needed)
- [ ] NFS working: ✅ / ⚠️  / ❌
- [ ] Latency acceptable: ✅ / ⚠️  / ❌

---

## Advanced Validation (Optional)

### Concurrent Load Test

**Purpose:** Verify multiple clients can flow through pipeline simultaneously

```bash
#!/bin/bash
# Send 3 concurrent clients through pipeline
for i in {1..3}; do
    maestro-conductor-sendSignal \
        --to "LILLy" \
        --type "REQUEST" \
        --subject "Load test client $i" \
        --body "Concurrent client $i" &
done
wait

# Monitor progress
watch -n 2 'ls /AI_Agents/signals | grep -c "PIPELINE_TRANSITION"'
```

**Success criteria:** All 3 clients progress without crosstalk

- [ ] Concurrent clients isolated
- [ ] No signal mixing
- [ ] All complete within 5 minutes

---

## Troubleshooting Decision Tree

```
Test Failed
├─ Is container running?
│  ├─ NO → Start: ssh ct20x; systemctl start maestro-conductor
│  └─ YES ↓
├─ Is NFS mounted?
│  ├─ NO → Mount: pct set 20x -mp0 /var/lib/vz/shared,mp=/mnt/shared
│  └─ YES ↓
├─ Are signals being created?
│  ├─ NO → Check conductor: journalctl -u maestro-conductor -n 20
│  └─ YES ↓
├─ Is agent responding?
│  ├─ NO → Check tmux: tmux send-keys -t agentname_session "echo test"
│  └─ YES ↓
└─ Contact Christian (escalation case)
```

---

## Post-Test Validation

### Review Agent Activity Logs

For each agent (LILLy, Mike, Clara, Aria, Finn, Anya, Atlas):

- [ ] Check daily activity log exists
- [ ] Verify test signals recorded
- [ ] Confirm no error messages
- [ ] Note any warnings

**Command:**
```bash
for agent in LILLy Mike Clara Aria Finn Anya Atlas; do
    echo "=== $agent ==="
    tail -20 /opt/maestro/AI_Agents/$agent/daily-activity.log
done
```

### Verify Git Tracking

- [ ] All test signals committed to git
- [ ] No uncommitted signal files
- [ ] Repository clean

**Command:**
```bash
cd /workspaces/Measai-Maestro
git status
git log --oneline -10 -- AI_Agents/signals/
```

### Review Test Results

- [ ] All test scripts executed successfully
- [ ] Result files saved to `qa-tests/results/`
- [ ] No critical failures (warn/defer acceptable)

---

## Success Criteria - Phase 6 Complete

✅ **All tests must pass for Phase 6 completion:**

- [ ] ✅ All 7 agents respond to signals
- [ ] ✅ All 7 agents send signals successfully
- [ ] ✅ CLI commands execute without error
- [ ] ✅ Activities logged in each agent's log
- [ ] ✅ Client flows LILLy → Mike → Clara → Aria → Finn → Anya → Atlas
- [ ] ✅ Test client progresses through all 7 agents
- [ ] ✅ MS365 email integration verified (or Phase 5 extension noted)
- [ ] ✅ Teams integration verified (or Phase 5 extension noted)
- [ ] ✅ NFS cross-container signals working
- [ ] ✅ All signal files tracked in git
- [ ] ✅ No errors in agent logs
- [ ] ✅ Signal latency < 5 seconds per transition
- [ ] ✅ Concurrent clients don't interfere

---

## Phase 6 Sign-Off

**When all tests pass:**

### Sign-Off Template

```markdown
# Phase 6 Validation: PASSED ✅

**Date:** [Date]  
**Time:** [Time UTC]  
**Tested By:** Copilot (QA Lead) + Claude (oversight)  

## Test Results Summary

| Test Group | Status | Notes |
|-----------|--------|-------|
| Individual Agents (1A-1G) | ✅ PASS | All 7 agents responding |
| Pipeline Flow (2A-2B) | ✅ PASS | Full E2E flow validated |
| Integrations (3A-3C) | ✅ PASS | NFS working, MS365/Teams ready |

## Key Metrics

- Total agents tested: 7
- Total CLI instances tested: 28
- Pipeline transitions tested: 12+ (LILLy→Mike→Clara→...→Atlas)
- Signal latency: <5 seconds per transition
- System uptime during tests: 100%

## Blockers / Deferred Items

- [ ] None - Ready for Phase 7

## Recommendation

**✅ READY FOR PHASE 7: GO-LIVE**

All systems validated. Recommend proceeding with Phase 7 (Go-Live) once Christian approval received.

---

Signed: [QA Lead]  
Date: [Date]  
Timestamp: [UTC Time]
```

---

## Next Steps After Phase 6

1. **Generate Phase 6 sign-off** (above template)
2. **Notify Claude and Christian:** "Phase 6 validation complete, ready for Phase 7"
3. **Archive test results:** Copy all test output to git
4. **Prepare Phase 7 checklist:** Go-live checklist and deployment procedures
5. **Await Christian approval:** Phase 7 requires Christian to enable production schedules

---

## Notes

- **Test frequency:** Phase 6 may be run multiple times (once per test cycle)
- **Remediation:** If any test fails, use troubleshooting guide to fix and re-run
- **Continuous validation:** Consider adding Phase 6 tests to CI/CD pipeline for ongoing validation
- **Success ratio:** 100% pass required for Phase 7 progression

---

*"Quality assurance is the guardian between dreams and production. Validate thoroughly."* — Copilot, QA Lead
