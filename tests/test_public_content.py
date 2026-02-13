from playwright.sync_api import sync_playwright

def run(playwright):
    browser = playwright.chromium.launch()
    page = browser.new_page()
    page.goto("http://localhost:8080/")

    # Check Title
    assert "DoorHan" in page.title()

    # Check Header Logo
    assert page.is_visible("text=DOORHAN")

    # Check Navigation (Mocked Items)
    assert page.is_visible("text=Products")
    assert page.is_visible("text=Projects")
    assert page.is_visible("text=Become a Dealer")

    # Check Hero Section (Translations might be missing, so check default text if English)
    # The default text in home.php is 'ENGINEERING<br>SOLUTIONS<br>OF THE FUTURE'
    # Playwright's text selector handles breaks gracefully usually, or we search for partial
    content = page.content()
    assert "ENGINEERING" in content
    assert "SOLUTIONS" in content
    assert "OF THE FUTURE" in content

    # Check Mocked Featured Products
    assert page.is_visible("text=Gate Systems")
    assert page.is_visible("text=Roller Systems")

    # Check Mocked News
    assert page.is_visible("text=Sheremetyevo Airport Hangars")

    print("All assertions passed!")
    browser.close()

with sync_playwright() as p:
    run(p)
