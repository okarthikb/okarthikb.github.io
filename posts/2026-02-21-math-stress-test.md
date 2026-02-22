---
title: "Math Stress Test: Tagged vs Untagged Display"
date: 2026-02-21
---

This post is a rendering stress test for display math, long lines, tags, alignment, and overflow behavior on mobile.

### Baseline repeated equation (untagged then tagged)

$$
\boxed{\int_{-\infty}^{\infty} e^{-x^2/2}\,dx = \sqrt{2\pi}}
$$

$$
\boxed{\int_{-\infty}^{\infty} e^{-x^2/2}\,dx = \sqrt{2\pi}} \tag{1}
$$

Expected behavior: both lines should stay centered; tagging should only add the right-side number.

### Wide equation (forced overflow)

$$
\log p_\theta(x_{1:T}) =
\sum_{t=1}^{T}
\log
\left(
\sum_{z_t=1}^{K}
\sum_{z_{t-1}=1}^{K}
p_\theta(x_t \mid z_t)\,p_\theta(z_t \mid z_{t-1})\,p_\theta(z_{t-1} \mid x_{1:t-1})
\right)
\tag{2}
$$

### Multiline aligned derivation with per-line tags

$$
\begin{align}
\mathcal{L}(\theta)
&= \mathbb{E}_{q(z\mid x)}
\left[\log p_\theta(x,z) - \log q(z\mid x)\right]
\tag{3}
\\
&= \mathbb{E}_{q(z\mid x)}
\left[\log p_\theta(x\mid z)\right]
- D_{\mathrm{KL}}(q(z\mid x)\,\|\,p(z))
\tag{4}
\\
&\le \log p_\theta(x)
\tag{5}
\end{align}
$$

### Same multiline block without tags (for alignment comparison)

$$
\begin{aligned}
\mathcal{L}(\theta)
&= \mathbb{E}_{q(z\mid x)}
\left[\log p_\theta(x,z) - \log q(z\mid x)\right]
\\
&= \mathbb{E}_{q(z\mid x)}
\left[\log p_\theta(x\mid z)\right]
- D_{\mathrm{KL}}(q(z\mid x)\,\|\,p(z))
\\
&\le \log p_\theta(x)
\end{aligned}
$$

### Category-theory flavored equalities

$$
\mathrm{Hom}_{\mathcal{C}}(A \otimes B, C)
\cong
\mathrm{Hom}_{\mathcal{C}}(A, [B,C])
\cong
\mathrm{Nat}\!\left(h_A \times h_B, h_C\right)
\tag{6}
$$

$$
\begin{aligned}
F(\operatorname{colim}_{i \in I} X_i)
&\cong \operatorname{colim}_{i \in I} F(X_i)
\\
G(\operatorname{lim}_{j \in J} Y_j)
&\cong \operatorname{lim}_{j \in J} G(Y_j)
\end{aligned}
$$

### Matrix-heavy block

$$
\Sigma =
\begin{bmatrix}
\sigma_{11} & \sigma_{12} & \cdots & \sigma_{1n} \\
\sigma_{21} & \sigma_{22} & \cdots & \sigma_{2n} \\
\vdots      & \vdots      & \ddots & \vdots      \\
\sigma_{n1} & \sigma_{n2} & \cdots & \sigma_{nn}
\end{bmatrix},
\qquad
\Sigma^{-1}
=
\frac{1}{\det(\Sigma)}\,\operatorname{adj}(\Sigma)
\tag{7}
$$

### Literal delimiter checks (should not become math)

- `\$not math\$`
- `\(not math\)`

Inline check in code spans: `\$this is literal\$` and `\(this is also literal\)`.

Inline check in plain text (without code): <span class="no-math">\\(this is also literal\\)</span> and <span class="no-math">\$this is literal\$</span>.
