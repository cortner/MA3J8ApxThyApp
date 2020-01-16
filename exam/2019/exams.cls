%% A LaTeX2e class (based on article.cls) by John Rawnsley for 
%% Warwick University Mathematics Department examinations.
%%
%% With help from Brian Fowler - use .aux file to track last page
%% and automate CONTINUED/END.
%%
%% Added support for resit exams 1998-03-04
%% Revamped for Miles 1998-12-09
%% Variable lengths for exams allowed 1999-01-21
%% Multipart exams allowed 2000-04-28
%% No calculators added 2003-11-09
%% Question continued added at request of Bob Kerr 2004-12-06
%% Space for solutions after exam added at Miles' request 2005-02-22
%% Add up the marks for each question 2007-02-11 (Jochen Voss)
%% Geometry package added to get A4 in PDFs with pdflatex 2009-03-03 (JR)
%% Turned off page numbers in solutions as they did not correspond to reality 2012-03-01
%%
\def\fileversion{v1.9a}
\def\filedate{2012/03/01}
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{exams}[\filedate\space\fileversion\space
 Mathematics examinations class]
%%
%% Based on article class
%%
\LoadClass[a4paper,12pt]{article}

\usepackage{calc,geometry}

%%
%%  A4, single-sided parameters
%%
\setlength{\textheight}{9.5truein}
\setlength{\textwidth}{6.2truein}
\setlength{\topmargin}{-0.5truein}
\setlength{\oddsidemargin}{0pt}
\setlength{\evensidemargin}{0pt}
\setlength{\headheight}{2\headheight}
\addtolength{\textheight}{-\headheight}
\@twosidefalse

%%
%%  Some skips
%%
\def\bigskip{\par\vspace{\baselineskip}}
\def\medskip{\par\vspace{.5\baselineskip}}
\def\smallskip{\par\vspace{.25\baselineskip}}

%% 
%% Default enumerate label format
%% 
\renewcommand{\theenumi}{\alph{enumi}}
\renewcommand{\labelenumi}{\theenumi)}
\renewcommand{\theenumii}{\roman{enumii}}


%%
%% The 'question' environment. The number is automatically entered
%% and a line drawn at the end of each question. Automates "continued"
%% when a question splits across 2 or more pages.
%%
\def\q@c{}
\def\q@ceven{}
\def\q@codd{}
\newcount\qpage
\newif\ifq@compulsory \q@compulsoryfalse
\newif\ifin@question \in@questionfalse
\newcounter{question}
\def\question{\qpage=\number\c@page\stepcounter{question}%
\ifq@compulsory\ifcase\c@question \or \medskip\noindent\textbf{COMPULSORY QUESTION}\medskip
 \or \medskip\noindent\textbf{OPTIONAL QUESTIONS}\medskip \fi\fi
\marktotal=0
\list {}{\itemindent\z@\leftmargin1.5em\labelwidth1em}
 \item[{\bf\thequestion.}]\ifnum\qpage=\c@page\global\in@questiontrue\gdef\q@c{Question \thequestion\ continued}\fi}
\def\endquestion{\global\in@questionfalse\gdef\q@c{}%
\ifnum\marktotal>0
\message{total marks for question \thequestion: \the\marktotal^^J}\fi
 \nopagebreak[3]\endlist\nopagebreak[3]\vspace{6pt}\nopagebreak[3]\hrule
  \par\vspace{6pt}\par}

%%
%%  Data for title and rubric
%%
\def\examcode#1{\gdef\@examcode{#1}}
\def\examtitle#1{\gdef\@examtitle{#1}}
\def\examdate#1{\gdef\@examdate{#1}}
\def\examyear#1{\gdef\@examyear{#1}\ifcase\@examyear
\gdef\@@year{MSc}\gdef\@msc{}\or
\gdef\@@year{FIRST YEAR}\or
\gdef\@@year{SECOND YEAR}\or
\gdef\@@year{THIRD YEAR}\or
\gdef\@@year{FOURTH YEAR}\else\gdef\@@year{MSc}\gdef\@msc{}\fi}
\def\examlength#1{\gdef\@examlength{#1}}
\def\examtime#1{\gdef\@examtime{#1}}
\let\@examtime\undefined
\def\marks{\gdef\@marks{ }\gdef\@@marks{ }\message{%
^^JMarks in margin requested.
^^JWill display the total for each question.^^J^^J}}
\let\@marks\undefined
\newcount\marktotal
\def\mark#1{\marginpar{\bf\ [#1]}\ifx\@@marks\undefined
\expandafter\message{^^J*** \noexpand\mark used! Add \noexpand\marks to the 
preamble. ***^^J^^J}\fi\gdef\@@marks{ }\gdef\@@@marks{ }%
\global\advance\marktotal by#1}
\let\@@marks\undefined
\let\@@@marks\undefined
\def\@half{\raise.5ex\hbox{$\!\scriptscriptstyle{\bf1\over2}\,$}}
\def\@@resit{}
\def\resit{\gdef\@@resit{RESIT}}
\def\multisection{\gdef\@multisection{ }}
\let\@multisection\undefined
\newif\ifnoc@lc \noc@lctrue
\def\calculators{\noc@lcfalse}
%%
%% Check all the data has been supplied
%%
\newlinechar=`\^^J
\def\@check#1#2{\message{^^J#2}\ifx#1\@undefined 
\gdef\@missingdata{}\message{****}\else\message{#1}\fi}
\def\@end{\expandafter\fi\expandafter\end{document}}
\def\@doCheck{%
\message{^^JChecking data...}
\@check{\@examcode  }{examcode....}
\@check{\@examtitle }{examtitle...}
\@check{\@examdate  }{examdate....}
\@check{\@examyear  }{examyear....}
\ifx\@multisection\undefined\@check{\@examlength}{examlength..}\fi
\ifx\@examtime\undefined\else \message{^^Jexamtime.... \@examtime\space hours}\fi
\ifnoc@lc\message{^^JNo calculators...}\else\message{^^JCalculators allowed...}\fi
\ifx\@missingdata\@undefined \message{^^JData OK...^^J}%
\message{If you see the message "LaTeX Warning: Label(s) 
may have changed."^^Jthen rerun latex to get the end of page
messages correct.^^J^^J}
\else\message{^^JMissing data. Stopping...^^J}\@end\fi}
%%
%% Check the data then do exam title at \begin{document}
%%
\AtBeginDocument{\parindent0pt
}
%% kill maketitle
\let\maketitle\relax
%%
\newcount\l@stpage \l@stpage=0

\newenvironment{exam}{%
\@doCheck
\def\@nehour{1}
{\bf THE UNIVERSITY OF WARWICK}
\bigskip
{\bf \@@year{} \@@resit{} EXAMINATION: \@examdate
\bigskip
\@examtitle}
\bigskip
\doubleline
{Time Allowed: \ifx\@examtime\undefined\ifx\@msc\undefined{\bf 
 \ifcase \@examlength
   No time\or\@half{} hour \or1 hour \or1\@half{} hours\or
   2 hours \or2\@half{} hours \or3 hours\fi}%
\else
 3 hours
\fi\else {\bf \@examtime\ \ifx\@examtime\@nehour hour \else hours\fi} \fi}
\bigskip
\ifx\@msc\undefined\ug@rubric\else\msc@rubric\fi
\doubleline
\par
\renewcommand{\baselinestretch}{1.15}
\rm}{%
\ifx\@marks\undefined\else\ifx\@@@marks\undefined\message{^^J*** \noexpand\marks
used in preamble, but no \noexpand\mark{} given! ***^^J^^J}\fi\fi
 \if@filesw\immediate\write\@mainaux{%
  \string\gdef\string\@lastpage{\thepage}}\fi
\ifx\@missingdata\@undefined \ifx\@msc\undefined
 \addtocounter{question}{-1}\else\fi\fi\vfill\eject}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Exam with a compulsory first question
%%
\newenvironment{examcomp1}{\global\q@compulsorytrue
\@doCheck
\def\@nehour{1}
{\bf THE UNIVERSITY OF WARWICK}
\bigskip
{\bf \@@year{} \@@resit{} EXAMINATION: \@examdate
\bigskip
\@examtitle}
\bigskip
\singleline
{Time Allowed: \ifx\@examtime\undefined\ifx\@msc\undefined{\bf 
 \ifcase \@examlength
   No time\or\@half{} hour \or1 hour \or1\@half{} hours\or
   2 hours \or2\@half{} hours \or3 hours\fi}%
\else
 3 hours
\fi\else {\bf \@examtime\ \ifx\@examtime\@nehour hour \else hours\fi} \fi}
\bigskip
\ifx\@msc\undefined\ug@comprubric\else\msc@rubric\fi
\singleline
\par
\renewcommand{\baselinestretch}{1.15}
\rm}{%
\ifx\@marks\undefined\else\ifx\@@@marks\undefined\message{^^J*** \noexpand\marks
used in preamble, but no \noexpand\mark{} given! ***^^J^^J}\fi\fi
 \if@filesw\immediate\write\@mainaux{%
  \string\gdef\string\@lastpage{\thepage}}\fi
\ifx\@missingdata\@undefined \ifx\@msc\undefined
 \addtocounter{question}{-1}\else\fi\fi\vfill\eject}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%
%% Check for missing data
%%
\AtEndDocument{%
}


%%
%% Put code in running head and pagenumber at foot
%% Fix continued... issues
\newbox\t@mpe
\newbox\t@mpo
\ifx\@lastpage\undefined\def\@lastpage{0}\fi
\def\ps@examheadings{%
  \def\@oddfoot{\ifnum\value{page}>\@lastpage\else\ifnum\@lastpage=1{\hfill\bf \makebox[0in][r]{END}}\else
  \ifnum\value{page}=\@lastpage\vbox{\hfill {\bf\thepage} \hfill\bf \makebox[0in][r]{END}}\else
  \vbox{\hfill {\bf\thepage} \hfill\ifin@question\makebox[0in][r]{\bf \q@c\ overleaf}\global\sbox\t@mpe{\hbox{\bf\thequestion}}\gdef\q@ceven{\par Question \usebox\t@mpe\ continued}\else\gdef\q@ceven{}\makebox[0in][r]{\bf CONTINUED}\fi}\fi\fi\fi}
%
  \def\@evenfoot{\ifnum\value{page}>\@lastpage\else\ifnum\@lastpage=1{\hfill\bf \makebox[0in][r]{END}}\else
  \ifnum\value{page}=\@lastpage\vbox{\hfill {\bf\thepage} \hfill\bf \makebox[0in][r]{END}}\else
  \vbox{\hfill {\bf\thepage} \hfill\ifin@question\makebox[0in][r]{\bf \q@c\ overleaf}\global\sbox\t@mpo{\hbox{\bf\thequestion}}\gdef\q@codd{\par Question \usebox\t@mpo\ continued}\else\gdef\q@codd{}\makebox[0in][r]{\bf CONTINUED}\fi}\fi\fi\fi}
  \def\@oddhead{\hbox{\parbox{5in}{\noindent\bf \@examcode\hfil~\par \q@codd\hfil}}\hfil\gdef\q@codd{}}
  \def\@evenhead{\hbox{\parbox{5in}{\noindent\bf \@examcode\hfil~\par \q@ceven\hfil}}\hfil\gdef\q@ceven{}}}
\pagestyle{examheadings}
%%
%% Some useful macros
%%
\def\singleline{\bigskip\par\hrule\bigskip\par}
\def\doubleline{\bigskip\par\hrule\vglue1pt\hrule\bigskip\par}

%%
%% Solutions
%%

\newenvironment{solutions}{%
}{%
}

\newcounter{solution}\setcounter{solution}{0}
\newenvironment{solution}{%
\newpage\stepcounter{solution}
\centerline{MATHEMATICS DEPARTMENT}
\centerline{\ifx\@msc\undefined\@@year\ UNDERGRADUATE\else MSC\fi\ EXAMS -- \@examdate}\bigskip\par
Course Title: \@examtitle\bigskip\par
Model Solution No: \thesolution\bigskip\par\let\@oddfoot\relax\let\@evenfoot\relax}{%
}



%%
%% MSc rubric
%%
\def\msc@rubric{%
Candidates should attempt {\bf all 4} questions. However more credit will 
be given for complete answers than for a number of fragments.
\bigskip

Read carefully the instructions on the answer book and make sure that 
the numbers required are entered on each answer book.}

%%
%% UG rubric old style
%%
\def\ug@rubric{Read carefully the instructions on the answer book and
make sure that the particulars required are entered on each answer book.
\ifnoc@lc\bigskip

Calculators are not needed and are not permitted in this examination.
\fi\bigskip
\ifx\@multisection\undefined ANSWER \@examlength{} QUESTIONS.
\smallskip
If you have answered more than the required \@examlength\ questions in 
this examination, you will only be given credit for your 
\@examlength\ best answers.
\else
A separate answer book must be used for each section.\smallskip\fi
\ifx\@marks\@undefined\else
\bigskip
 The numbers in the margin indicate approximately how many marks
 are available for each part of a question.\fi
}

%%
%% UG rubric with compulsory question
%%
\def\ug@comprubric{Read carefully the instructions on the answer book and
make sure that the particulars required are entered on each answer book.
\ifnoc@lc\bigskip

\textbf{Calculators are not needed and are not permitted in this examination.}
\fi\bigskip

Candidates should answer COMPULSORY QUESTION 1 and THREE QUESTIONS out
of the four optional questions 2, 3, 4 and 5.\medskip

The compulsory question is worth 40\% of the available marks. Each
optional question is worth 20\%.\medskip

If you have answered more than the compulsory Question 1 and three
optional questions, you will only be given credit for your QUESTION 1
and THREE OTHER best answers.

\ifx\@marks\@undefined\else
\bigskip
 The numbers in the margin indicate approximately how many marks
 are available for each part of a question.\fi
}



%%
%% For multisection exams (assumed to be UG)
%%
%#1 Title of section
%#2 Length of exam
%#3 Number of questions for full credit
%
\def\section#1#2#3{\setcounter{question}{0}
\ifx\@multisection\undefined\message{***Exams Class Warning***^^JUse of 
section only valid in a multi-section exam.^^J^^J}\else
\ifnum\c@page>1\newpage\fi
{\textbf{#1}
\medskip Time allowed: #2\medskip 
ANSWER #3{} QUESTIONS.
\smallskip
If you have answered more than the required #3{} questions in 
this section, you will only be given credit for your 
#3{} best answers.
}\singleline\fi
}
%
%#1 Title of section
%#2 Length of exam
%#3 Number of questions for full credit
%#3 = number of optional  questions
%#4 = number of marks for compulsory qu.1
%#5 = number of marks for each optional  question
\newcounter{xsectiontotal}
\def\xsection#1#2#3#4#5{\setcounter{question}{0}\setcounter{xsectiontotal}{#4+#3*#5}
\ifx\@multisection\undefined\message{***Exams Class Warning***^^JUse of
section only valid in a multi-section exam.^^J^^J}\else
\ifnum\c@page>1\newpage\fi
{\textbf{#1}
\medskip Time allowed: #2\medskip
ANSWER QUESTION 1 AND #3{} MORE QUESTIONS.
\smallskip
Question 1 is compulsory and is worth #4{} marks.
Each of the other #3{} questions is worth #5{} marks.
This section is marked out of \thexsectiontotal{}.  If you have answered
more than the required number of questions in this section,
you will only be given credit for question 1 and for the best
#3{} of your other answers.
}\singleline\fi
}
\endinput
