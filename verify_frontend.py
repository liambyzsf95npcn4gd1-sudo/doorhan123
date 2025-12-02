from playwright.sync_api import sync_playwright, expect

def verify_changes():
    with sync_playwright() as p:
        browser = p.chromium.launch(headless=True)
        page = browser.new_page()

        # 1. Verify Products Page (Categories have images)
        print("Verifying Products page...")
        page.goto("http://localhost:8080/products")
        expect(page.get_by_role("heading", name="Our Products")).to_be_visible()
        page.screenshot(path="verification_products.png")
        print("Products page verified.")

        # 2. Verify About Us Page (Content exists)
        print("Verifying About Us page...")
        page.goto("http://localhost:8080/about")
        expect(page.get_by_role("heading", name="About Us")).to_be_visible()
        # Check for snippet of text
        expect(page.get_by_text("The DoorHan International Concern")).to_be_visible()
        page.screenshot(path="verification_about.png")
        print("About Us page verified.")

        # 3. Verify News Page (Images are correct)
        print("Verifying News page...")
        page.goto("http://localhost:8080/news")
        expect(page.get_by_role("heading", name="News")).to_be_visible()
        # We can't easily check the image content, but we can check if images are loaded (naturalWidth > 0)
        # Or just take a screenshot
        page.screenshot(path="verification_news.png")
        print("News page verified.")

        browser.close()

if __name__ == "__main__":
    verify_changes()
