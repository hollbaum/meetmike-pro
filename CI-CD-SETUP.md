# Meet Mike CI/CD Pipeline Setup

**Date:** 2025-11-27  
**Status:** ✅ Ready for Review  
**Deployed to:** meetmike.pro (Coolify)

---

## Overview

GitHub Actions CI/CD pipeline configured for automated testing, type checking, building, and deployment to Coolify.

## Pipeline Stages

### 1. **Lint (ESLint)**
- Runs on every push and pull request
- Validates code style and best practices
- Node.js 20 environment
- Dependencies cached for faster execution

### 2. **Type Check (TypeScript)**
- Runs on every push and pull request
- Full TypeScript compilation check
- Ensures type safety
- Catches type errors before build

### 3. **Build Verification**
- Runs on every push and pull request
- Builds Next.js application
- Verifies build succeeds
- Supports environment variables via secrets

### 4. **Deploy to Coolify**
- **Triggered:** Only on merge to `main` branch
- **Prerequisite:** Lint, Type Check, and Build must pass
- **Action:** Calls Coolify webhook at 136.243.148.151
- **Result:** Auto-deploys to meetmike.pro

---

## Workflow File

**Location:** `.github/workflows/ci-cd.yml`

**Triggers:**
- Push to `main` or `master` branch
- Pull requests to `main` or `master` branch

**Jobs:**
1. `lint` - ESLint validation
2. `type-check` - TypeScript type checking
3. `build` - Next.js build verification
4. `deploy` - Coolify webhook trigger (main branch only)

---

## Required Secrets

Configure these in GitHub repository settings → Secrets and variables → Actions:

### 1. `COOLIFY_WEBHOOK_URL`
- **Value:** Coolify webhook URL provided by deployment
- **Used:** Deploy job triggers webhook
- **Format:** `https://136.243.148.151:3000/webhooks/...`

### 2. `NEXT_PUBLIC_API_URL` (Optional)
- **Value:** API endpoint for Next.js frontend
- **Used:** Build step
- **Default:** Can be empty or set in `.env.production`

### Setup Instructions:
1. Go to GitHub repository settings
2. Navigate to Secrets and variables → Actions
3. Click "New repository secret"
4. Add `COOLIFY_WEBHOOK_URL` with webhook value
5. (Optional) Add `NEXT_PUBLIC_API_URL` if needed

---

## Deployment Flow

```
Developer pushes to main
         ↓
Lint validation (ESLint)
         ↓
Type checking (TypeScript)
         ↓
Build verification (Next.js)
         ↓
All checks pass?
    ↙ (Yes)        (No) ↘
Deploy                   PR Feedback
  ↓
Coolify webhook triggered
  ↓
Auto-deploy to meetmike.pro
  ↓
✅ Live on production
```

---

## Monitoring Deployments

1. **GitHub Actions:** View workflow runs in Actions tab
2. **Coolify:** Monitor deployments at server (136.243.148.151)
3. **Website:** Verify at https://meetmike.pro

---

## Development Workflow

### Local Development
```bash
cd app
npm install
npm run dev
```

### Before Pushing
```bash
# Check lint
npm run lint

# Check types
npx tsc --noEmit

# Build
npm run build
```

### Pull Requests
- Workflow runs automatically
- Review results before merge
- All checks must pass for deployment

### Merging to Main
- Only merged PRs deploy
- Direct pushes to main also trigger deployment
- Webhook notifies Coolify immediately

---

## Troubleshooting

### Lint Failures
- Check ESLint output in Actions logs
- Fix issues locally: `npm run lint -- --fix`
- Commit and push fixed code

### TypeScript Errors
- Check error details in Actions logs
- Fix types in source code
- Run `npx tsc --noEmit` locally to verify

### Build Failures
- Check build output in Actions logs
- Verify environment variables are set
- Test build locally: `npm run build`

### Deployment Not Triggering
- Verify webhook URL is set in GitHub secrets
- Check Coolify server is running
- Review deployment logs at 136.243.148.151

---

## Next Steps

1. **Configure GitHub Secrets**
   - Add `COOLIFY_WEBHOOK_URL` to repository

2. **Test Workflow**
   - Create test PR to verify lint/type-check/build
   - Merge to main to test deployment

3. **Monitor Production**
   - Watch Actions tab for workflow runs
   - Verify deployments at meetmike.pro

4. **SSL Certificate**
   - Once ACME issue resolved, https://meetmike.pro will be fully secure

---

## References

- **GitHub Actions:** https://docs.github.com/en/actions
- **Next.js Build:** https://nextjs.org/docs/app/building-your-application/deploying
- **Coolify:** Documentation at deployment server
- **Repository:** Meet Mike project in Measai-Maestro

---

**Setup completed by:** Copilot  
**Date:** 2025-11-27T15:35 UTC  
**Status:** Ready for team review and GitHub setup
