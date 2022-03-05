let page = document.querySelector(".page"),
    body = document.querySelector("body");


body.onresize = () => {
  let bodyWidth = parseInt(window.getComputedStyle(body).width),
      pageWidth = parseInt(window.getComputedStyle(page).width);

  if (pageWidth > 0.94 * bodyWidth) {
    let margin = parseInt((bodyWidth - pageWidth) / 2);
    page.style.marginTop = margin + "px";
    page.style.marginBottom = margin + "px";
  }
}