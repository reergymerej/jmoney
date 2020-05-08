<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN"
   "http://www.w3.org/TR/html4/strict.dtd">

<html>
<head>
  <title></title>
  <meta http-equiv="content-type" content="text/html; charset=latin-1">
  <style type="text/css">
td.linenos { background-color: #f0f0f0; padding-right: 10px; }
span.lineno { background-color: #f0f0f0; padding: 0 5px 0 5px; }
pre { line-height: 125%; }
body .hll { background-color: #ffffcc }
body  { background: #ffffff; }
body .c { color: #008800; font-style: italic } /* Comment */
body .err { color: #a61717; background-color: #e3d2d2 } /* Error */
body .k { color: #000080; font-weight: bold } /* Keyword */
body .cm { color: #008800; font-style: italic } /* Comment.Multiline */
body .cp { color: #008080 } /* Comment.Preproc */
body .c1 { color: #008800; font-style: italic } /* Comment.Single */
body .cs { color: #008800; font-weight: bold } /* Comment.Special */
body .gd { color: #000000; background-color: #ffdddd } /* Generic.Deleted */
body .ge { font-style: italic } /* Generic.Emph */
body .gr { color: #aa0000 } /* Generic.Error */
body .gh { color: #999999 } /* Generic.Heading */
body .gi { color: #000000; background-color: #ddffdd } /* Generic.Inserted */
body .go { color: #888888 } /* Generic.Output */
body .gp { color: #555555 } /* Generic.Prompt */
body .gs { font-weight: bold } /* Generic.Strong */
body .gu { color: #aaaaaa } /* Generic.Subheading */
body .gt { color: #aa0000 } /* Generic.Traceback */
body .kc { color: #000080; font-weight: bold } /* Keyword.Constant */
body .kd { color: #000080; font-weight: bold } /* Keyword.Declaration */
body .kn { color: #000080; font-weight: bold } /* Keyword.Namespace */
body .kp { color: #000080; font-weight: bold } /* Keyword.Pseudo */
body .kr { color: #000080; font-weight: bold } /* Keyword.Reserved */
body .kt { color: #000080; font-weight: bold } /* Keyword.Type */
body .m { color: #0000FF } /* Literal.Number */
body .s { color: #0000FF } /* Literal.String */
body .na { color: #FF0000 } /* Name.Attribute */
body .nt { color: #000080; font-weight: bold } /* Name.Tag */
body .ow { font-weight: bold } /* Operator.Word */
body .w { color: #bbbbbb } /* Text.Whitespace */
body .mf { color: #0000FF } /* Literal.Number.Float */
body .mh { color: #0000FF } /* Literal.Number.Hex */
body .mi { color: #0000FF } /* Literal.Number.Integer */
body .mo { color: #0000FF } /* Literal.Number.Oct */
body .sb { color: #0000FF } /* Literal.String.Backtick */
body .sc { color: #800080 } /* Literal.String.Char */
body .sd { color: #0000FF } /* Literal.String.Doc */
body .s2 { color: #0000FF } /* Literal.String.Double */
body .se { color: #0000FF } /* Literal.String.Escape */
body .sh { color: #0000FF } /* Literal.String.Heredoc */
body .si { color: #0000FF } /* Literal.String.Interpol */
body .sx { color: #0000FF } /* Literal.String.Other */
body .sr { color: #0000FF } /* Literal.String.Regex */
body .s1 { color: #0000FF } /* Literal.String.Single */
body .ss { color: #0000FF } /* Literal.String.Symbol */
body .il { color: #0000FF } /* Literal.Number.Integer.Long */

  </style>
</head>
<body>
<h2></h2>

<div class="highlight"><pre><a name="n-1"></a><span class="lineno"> 1</span> <span class="c">#!/usr/bin/env bash</span>
<a name="n-2"></a><span class="lineno"> 2</span> <span class="c"># journal_backup.sh - Back up my journals to an archive and create a new clean entry</span>
<a name="n-3"></a><span class="lineno"> 3</span> <span class="c"># use: sh journal_backup.sh [single word journal name]</span>
<a name="n-4"></a><span class="lineno"> 4</span> <span class="c"># example: sh journal_backup.sh Professional</span>
<a name="n-5"></a><span class="lineno"> 5</span> <span class="c"># This script preserves information form the current page or looks to a template file to create a</span>
<a name="n-6"></a><span class="lineno"> 6</span> <span class="c"># new page. It then appends the entire current page to the archive and creates a new page using</span>
<a name="n-7"></a><span class="lineno"> 7</span> <span class="c"># the preserved info or template. Currently only uses markdown format because markdown is cool.</span>
<a name="n-8"></a><span class="lineno"> 8</span> 
<a name="n-9"></a><span class="lineno"> 9</span> <span class="c"># Define the file names for the current journal and archive</span>
<a name="n-10"></a><span class="lineno">10</span> <span class="nv">JOURNAL</span><span class="o">=</span><span class="nv">$1_Journal_Current</span>.markdown
<a name="n-11"></a><span class="lineno">11</span> <span class="nv">ARCHIVE</span><span class="o">=</span><span class="nv">$1_Journal_Archive</span>.markdown
<a name="n-12"></a><span class="lineno">12</span> 
<a name="n-13"></a><span class="lineno">13</span> <span class="c"># Now with case instead of if statement</span>
<a name="n-14"></a><span class="lineno">14</span> <span class="k">case</span> <span class="s2">&quot;$1&quot;</span> in
<a name="n-15"></a><span class="lineno">15</span> 	<span class="s2">&quot;Professional&quot;</span><span class="o">)</span> 
<a name="n-16"></a><span class="lineno">16</span> 		<span class="c"># If this is my professional journal, then we need to preserve everything still in the </span>
<a name="n-17"></a><span class="lineno">17</span> 		<span class="c"># &#39;## Things and Stuff&#39; block, which exists between that 2nd level headline and the</span>
<a name="n-18"></a><span class="lineno">18</span> 		<span class="c"># &#39;## Completed&#39; headline. We can add in cases here for additional journals as time goes on.</span>
<a name="n-19"></a><span class="lineno">19</span> 		<span class="c"># For example, the Nethack journal has it&#39;s own structure, and the Personal journal basically</span>
<a name="n-20"></a><span class="lineno">20</span> 		<span class="c"># has no structure so we can do WTF we want there.</span>
<a name="n-21"></a><span class="lineno">21</span> 		<span class="nv">PRESERVE</span><span class="o">=</span><span class="k">$(</span>sed -n <span class="s2">&quot;/## Things and Stuff/,/## Completed/p&quot;</span> <span class="nv">$JOURNAL</span><span class="k">)</span>;;
<a name="n-22"></a><span class="lineno">22</span> 
<a name="n-23"></a><span class="lineno">23</span> 	<span class="s2">&quot;Nethack&quot;</span><span class="o">)</span>
<a name="n-24"></a><span class="lineno">24</span> 		<span class="c"># If this is my Nethack journal then we just write the whole thing to archive and then preserve</span>
<a name="n-25"></a><span class="lineno">25</span> 		<span class="c"># the basic goals and the headlines, which we store in a template file to avoid having to</span>
<a name="n-26"></a><span class="lineno">26</span> 		<span class="c"># write it all in here.</span>
<a name="n-27"></a><span class="lineno">27</span> 		<span class="nv">PRESERVE</span><span class="o">=</span><span class="k">$(</span>cat Nethack_Journal_Template.markdown<span class="k">)</span>;;
<a name="n-28"></a><span class="lineno">28</span> 
<a name="n-29"></a><span class="lineno">29</span> 	<span class="c"># I&#39;m just reserving this space for additional cases to be handled. I haven&#39;t yet defined</span>
<a name="n-30"></a><span class="lineno">30</span> 	<span class="c"># my personal journal.. which I think says a lot about me...</span>
<a name="n-31"></a><span class="lineno">31</span> 
<a name="n-32"></a><span class="lineno">32</span> 	<span class="c"># And a whoopsie message in case I fuck everything up because why not?</span>
<a name="n-33"></a><span class="lineno">33</span> 	*<span class="o">)</span> <span class="nb">echo</span> <span class="s2">&quot;Youze a big dummy.&quot;</span>; <span class="nb">exit</span> ;;
<a name="n-34"></a><span class="lineno">34</span> <span class="k">esac</span>
<a name="n-35"></a><span class="lineno">35</span> 
<a name="n-36"></a><span class="lineno">36</span> <span class="c"># These are my favorite modelines. Include them in the files!</span>
<a name="n-37"></a><span class="lineno">37</span> <span class="nv">MODELINES</span><span class="o">=</span><span class="s2">&quot;# vim: lbr ai showbreak=&gt;\ &quot;</span>
<a name="n-38"></a><span class="lineno">38</span> 
<a name="n-39"></a><span class="lineno">39</span> <span class="c"># If the archive already exists, use it. If not, create a new one with modelines at the bottom.</span>
<a name="n-40"></a><span class="lineno">40</span> <span class="k">if </span><span class="nb">test</span> -f <span class="s2">&quot;$ARCHIVE&quot;</span>; <span class="k">then</span>
<a name="n-41"></a><span class="lineno">41</span> <span class="k">	</span><span class="nb">echo</span> <span class="s2">&quot;Archiving $JOURNAL to $ARCHIVE&quot;</span>
<a name="n-42"></a><span class="lineno">42</span> <span class="k">else</span>
<a name="n-43"></a><span class="lineno">43</span> <span class="k">	</span><span class="nb">echo</span> <span class="s2">&quot;Creating $ARCHIVE for journal&quot;</span>
<a name="n-44"></a><span class="lineno">44</span> 	<span class="nb">echo</span> -e <span class="s2">&quot;$MODELINES\n\n&quot;</span> &gt; <span class="nv">$ARCHIVE</span>
<a name="n-45"></a><span class="lineno">45</span> <span class="k">fi</span>
<a name="n-46"></a><span class="lineno">46</span> 
<a name="n-47"></a><span class="lineno">47</span> <span class="c"># Append everything except the modelines from the current journal entry.</span>
<a name="n-48"></a><span class="lineno">48</span> head <span class="nv">$JOURNAL</span> --lines<span class="o">=</span>-1 &gt;&gt; <span class="nv">$ARCHIVE</span>
<a name="n-49"></a><span class="lineno">49</span> 
<a name="n-50"></a><span class="lineno">50</span> <span class="c"># Create the new page starting with the preserve text</span>
<a name="n-51"></a><span class="lineno">51</span> <span class="nb">echo</span> -e <span class="s2">&quot;# $(date)\n\n$PRESERVE\n\n\n$MODELINES&quot;</span> &gt; <span class="nv">$JOURNAL</span>
<a name="n-52"></a><span class="lineno">52</span> 
<a name="n-53"></a><span class="lineno">53</span> <span class="c"># I removed the automatic starting of the VIM process because it was superfluous. However, I</span>
<a name="n-54"></a><span class="lineno">54</span> <span class="c"># would like to see if there&#39;s a VIM instance running and open the new page in a new buffer</span>
<a name="n-55"></a><span class="lineno">55</span> <span class="c"># automatically.</span>
</pre></div>
</body>
</html>
