---
title: "Math Stress Test: Tagged vs Untagged Display"
date: 2026-02-21
---

This post is a rendering stress test for display math, short and long equations, tags, multiline alignment, and literal escape behavior.

### Baseline repeated equation (untagged then tagged)

$$
\boxed{\int_{-\infty}^{\infty} e^{-x^2/2}\,dx = \sqrt{2\pi}}
$$

$$
\boxed{\int_{-\infty}^{\infty} e^{-x^2/2}\,dx = \sqrt{2\pi}} \tag{1}
$$

Expected behavior: both lines should stay centered; tagging should only add the right-side number.

### Short tagged equations (dense numbering)

$$ a+b=c \tag{3} $$

$$ e^{i\pi}+1=0 \tag{4} $$

$$ \nabla \cdot \mathbf{E} = \frac{\rho}{\varepsilon_0} \tag{5} $$

$$ \det(AB)=\det(A)\det(B) \tag{6} $$

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

### Very wide rational expression (forced overflow)

$$
\frac{
\sum_{k=1}^{K}
\left(
\prod_{j=1}^{J}
\left(1+\alpha_{k,j}x_j+\beta_{k,j}x_j^2\right)
\right)
}
{
1+
\sum_{m=1}^{M}
\left(
\gamma_m
\sum_{n=1}^{N}\delta_{m,n}x_n
\right)^2
}
\tag{7}
$$

### Multiline derivation with per-line tags (`align`)

$$
\begin{align}
\mathcal{L}(\theta)
&= \mathbb{E}_{q(z\mid x)}
\left[\log p_\theta(x,z) - \log q(z\mid x)\right]
\tag{8}
\\
&= \mathbb{E}_{q(z\mid x)}
\left[\log p_\theta(x\mid z)\right]
- D_{\mathrm{KL}}(q(z\mid x)\,\|\,p(z))
\tag{9}
\\
&\le \log p_\theta(x)
\tag{10}
\end{align}
$$

### Longer per-line tagged system (`align`)

$$
\begin{align}
\mathbf{h}_t &= \sigma(W_h \mathbf{h}_{t-1} + U_h \mathbf{x}_t + \mathbf{b}_h) \tag{11} \\
\mathbf{o}_t &= W_o \mathbf{h}_t + \mathbf{b}_o \tag{12} \\
p(\mathbf{y}_t \mid \mathbf{x}_{\le t}) &= \operatorname{softmax}(\mathbf{o}_t) \tag{13} \\
\mathcal{J}(\theta) &= -\sum_{t=1}^{T}\log p(y_t^\star \mid \mathbf{x}_{\le t}) \tag{14}
\end{align}
$$

### Same multiline block without tags (alignment comparison)

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
\tag{15}
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
\tag{16}
$$

### Escape matrix (literal characters and delimiters)

The lines below should render as plain text, not math:

- Price literal: \$19.99
- Shell var literal: \$PATH
- Double-dollar literal text: \$\$TOKEN\$\$
- Literal backslash delimiters in prose: \\(not-math\\), \\[not-math\\]
- Literal braces: \{a,b,c\}
- Literal hash: \# heading-marker
- Literal underscore in prose: foo\_bar
- Literal percent: 100\% certainty
- Literal ampersand: R\&D

Inline check in plain text (without code): \$this is literal\$.
