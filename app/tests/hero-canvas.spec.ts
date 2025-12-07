import { test, expect } from '@playwright/test';

test.describe('Hero Canvas Mike', () => {
  test('should display hero canvas on page load', async ({ page }) => {
    await page.goto('http://localhost:3000', { waitUntil: 'networkidle' });
    
    // Check that hero canvas is visible
    const heroCanvas = page.locator('text=Hi. I\'m Mike.');
    await expect(heroCanvas).toBeVisible({ timeout: 5000 });
  });

  test('should show input field after typewriter completes', async ({ page }) => {
    await page.goto('http://localhost:3000', { waitUntil: 'networkidle' });
    
    // Wait for typewriter to complete
    await page.waitForTimeout(3000);
    
    // Check that input field is visible
    const input = page.locator('input[placeholder="Tell me about your project..."]');
    await expect(input).toBeVisible();
  });

  test('should be mobile responsive', async ({ page }) => {
    // Test mobile viewport
    await page.setViewportSize({ width: 375, height: 667 });
    
    await page.goto('http://localhost:3000', { waitUntil: 'networkidle' });
    
    // Check hero canvas is still visible
    const heroText = page.locator('text=Hi. I\'m Mike.');
    await expect(heroText).toBeVisible({ timeout: 5000 });
  });
});
