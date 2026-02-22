---
title: "Math Stress Test: KaTeX Torture Suite"
date: 2026-02-21
---

This post is an intentionally excessive KaTeX stress test for centering, equation tagging, multiline environments, overflow, boxed displays, and plain-text escaping.

### Centering baseline (same equation, untagged then tagged)

$$
\boxed{\int_{-\infty}^{\infty} e^{-x^2/2}\,dx = \sqrt{2\pi}}
$$

$$
\boxed{\int_{-\infty}^{\infty} e^{-x^2/2}\,dx = \sqrt{2\pi}} \tag{1}
$$

Expected behavior: both equations stay centered; the tag only adds a right-side label.

### Dense short tagged equations

$$ a+b=c \tag{2} $$
$$ x^2+y^2=z^2 \tag{3} $$
$$ \det(AB)=\det(A)\det(B) \tag{4} $$
$$ \nabla \cdot \mathbf{E} = \frac{\rho}{\varepsilon_0} \tag{5} $$
$$ \nabla \times \mathbf{E} = -\frac{\partial \mathbf{B}}{\partial t} \tag{6} $$
$$ \sum_{k=1}^{n} k = \frac{n(n+1)}{2} \tag{7} $$
$$ \sum_{k=1}^{n} k^2 = \frac{n(n+1)(2n+1)}{6} \tag{8} $$
$$ \prod_{k=1}^{n} (1+a_k) = 1 + \sum_{m=1}^{n} \sum_{1\le i_1<\cdots<i_m\le n} a_{i_1}\cdots a_{i_m} \tag{9} $$

### Overflow monster I

$$
\log p_\theta(x_{1:T}) =
\sum_{t=1}^{T}
\log
\left(
\sum_{z_t=1}^{K}
\sum_{z_{t-1}=1}^{K}
p_\theta(x_t \mid z_t)\,p_\theta(z_t \mid z_{t-1})\,p_\theta(z_{t-1} \mid x_{1:t-1})
\right)
\tag{10}
$$

### Overflow monster II (nested fraction + powers + sums)

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
\tag{11}
$$

### Overflow monster III (single-line width torture)

$$
\boxed{
\mathbb{P}\!\left(
\bigcap_{t=1}^{T}
\left\{
\left|
\sum_{i=1}^{n}
\left[
\left(
\prod_{j=1}^{m}
\left(1+\alpha_{t,i,j}u_j+\beta_{t,i,j}u_j^2\right)
\right)
\left(
\sum_{r=1}^{R}\gamma_{t,i,r}v_r
\right)
\right]
\right| \le \varepsilon_t
\right\}
\right)
}
\tag{12}
$$

### `align` with per-line tags

$$
\begin{align}
\mathcal{L}(\theta)
&= \mathbb{E}_{q(z\mid x)}
\left[\log p_\theta(x,z) - \log q(z\mid x)\right]
\tag{13}
\\
&= \mathbb{E}_{q(z\mid x)}
\left[\log p_\theta(x\mid z)\right]
- D_{\mathrm{KL}}(q(z\mid x)\,\|\,p(z))
\tag{14}
\\
&\le \log p_\theta(x)
\tag{15}
\end{align}
$$

### `align` system with many tags

$$
\begin{align}
\mathbf{h}_t &= \sigma(W_h \mathbf{h}_{t-1} + U_h \mathbf{x}_t + \mathbf{b}_h) \tag{16} \\
\mathbf{o}_t &= W_o \mathbf{h}_t + \mathbf{b}_o \tag{17} \\
p(\mathbf{y}_t \mid \mathbf{x}_{\le t}) &= \operatorname{softmax}(\mathbf{o}_t) \tag{18} \\
\ell_t(\theta) &= -\log p(y_t^\star \mid \mathbf{x}_{\le t}) \tag{19} \\
\mathcal{J}(\theta) &= \sum_{t=1}^{T}\ell_t(\theta) \tag{20} \\
\nabla_\theta \mathcal{J}(\theta) &= \sum_{t=1}^{T}\nabla_\theta \ell_t(\theta) \tag{21}
\end{align}
$$

### `alignat` with tags

$$
\begin{alignat}{2}
f(x)   &= x^4 + 2x^3 - x + 7, \qquad & f'(x)   &= 4x^3 + 6x^2 - 1 \tag{22} \\
g(x)   &= e^{x}\sin x,                & g'(x)   &= e^{x}(\sin x + \cos x) \tag{23} \\
h(x)   &= \ln(1+x^2),                 & h'(x)   &= \frac{2x}{1+x^2} \tag{24}
\end{alignat}
$$

### `gather` and `gathered`

$$
\begin{gather}
\int_{-\infty}^{\infty} e^{-x^2}\,dx = \sqrt{\pi} \tag{25} \\
\int_{0}^{\infty} x^{s-1}e^{-x}\,dx = \Gamma(s) \tag{26} \\
\zeta(s)=\frac{1}{\Gamma(s)}\int_0^\infty \frac{x^{s-1}}{e^x-1}\,dx \tag{27}
\end{gather}
$$

$$
\begin{gathered}
\left(
\sum_{k=1}^{n} a_k
\right)^2
=
\sum_{k=1}^{n} a_k^2
+ 2\sum_{1\le i<j\le n} a_i a_j
\\
\left(
\sum_{k=1}^{n} a_k
\right)^3
=
\sum_{k=1}^{n} a_k^3
+ 3\sum_{i\ne j} a_i^2 a_j
+ 6\sum_{1\le i<j<\ell\le n} a_i a_j a_\ell
\end{gathered}
$$

### Same derivation without tags (alignment comparison)

$$
\mathrm{Hom}_{\mathcal{C}}(A \otimes B, C)
\cong
\mathrm{Hom}_{\mathcal{C}}(A, [B,C])
\cong
\mathrm{Nat}\!\left(h_A \times h_B, h_C\right)
\tag{28}
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

### Matrix-heavy block with tag

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
\tag{29}
$$

### Block matrix + piecewise

$$
M =
\begin{bmatrix}
A & B \\
C & D
\end{bmatrix},
\qquad
M^{-1} =
\begin{bmatrix}
(A-BD^{-1}C)^{-1} & -A^{-1}B(D-CA^{-1}B)^{-1} \\
-D^{-1}C(A-BD^{-1}C)^{-1} & (D-CA^{-1}B)^{-1}
\end{bmatrix}
\tag{30}
$$

$$
f(x)=
\begin{cases}
\sin(x)/x, & x \ne 0 \\
1, & x = 0
\end{cases}
\tag{31}
$$

### Pseudo-diagram flavored formulas

$$
A \xrightarrow{f} B \xrightarrow{g} C,\qquad g\circ f = h
\tag{32}
$$

$$
\begin{array}{ccc}
X & \xrightarrow{\ \alpha\ } & Y \\
\downarrow {\scriptstyle u} &  & \downarrow {\scriptstyle v} \\
X' & \xrightarrow{\ \beta\ } & Y'
\end{array}
\qquad \text{with } v\circ\alpha = \beta\circ u
\tag{33}
$$

### Box parade

$$
\boxed{\boxed{\sum_{k=1}^{n} k = \frac{n(n+1)}{2}}}
\tag{34}
$$

$$
\boxed{
\begin{aligned}
\forall \varepsilon > 0\ \exists N\ \forall n\ge N:\ 
\left|a_n - L\right| < \varepsilon
\end{aligned}
}
\tag{35}
$$

### Escape matrix (plain text, no code spans)

Everything below should remain plain text and not become math:

- Dollar literal: \$19.99
- Shell var literal: \$PATH
- Literal double-dollar: \$\$NOT\_MATH\$\$
- Literal inline delimiters: \$x+y\$ and \$\alpha\$
- Literal display delimiters: \$\$x^2+y^2\$\$
- Literal backslash-paren delimiters: \\(x+y\\)
- Literal backslash-bracket delimiters: \\[x+y\\]
- Literal braces: \{a,b,c\}
- Literal percent: 100\% complete
- Literal underscore: file\_name\_v2
- Literal hash: \# heading-marker
- Literal ampersand: R\&D
- Literal pipe: a \| b
- Literal backtick: \`inline\`

Inline prose escape checks:

I can write \$100, \$x\$, \$\$y\$\$, \\(z\\), and \\[w\\] in normal text.
