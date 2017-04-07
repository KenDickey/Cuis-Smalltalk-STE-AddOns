'From Cuis 5.0 of 7 November 2016 [latest update: #3075] on 2 April 2017 at 2:59:07 pm'!
'Description I add user interface elements for StyleSet, ParagraphStyles and CharacterStyles for a StyledTextEditor.'!
!provides: 'StyledTextAddOns' 1 0!
!requires: 'StyledTextInstaller' 1 6 nil!
!requires: 'Morph-MetaProperties' 1 59 nil!
!classDefinition: #CharacterStyleEditor category: #'StyledTextAddOns'!
MenuMorph subclass: #CharacterStyleEditor
	instanceVariableNames: 'styledTextModel targetStyle styleName styleShortcut textFont textEmphasis textColor'
	classVariableNames: 'CharSetMetaProps'
	poolDictionaries: ''
	category: 'StyledTextAddOns'!
!classDefinition: 'CharacterStyleEditor class' category: #'StyledTextAddOns'!
CharacterStyleEditor class
	instanceVariableNames: ''!

!classDefinition: #ParagraphStyleEditor category: #'StyledTextAddOns'!
CharacterStyleEditor subclass: #ParagraphStyleEditor
	instanceVariableNames: 'paragraphAlignment firstLineIndent restLinesIndent rightLineIndent verticalSpaceBefore verticalSpaceAfter bulletPatternString'
	classVariableNames: 'ParagraphMetaProps'
	poolDictionaries: ''
	category: 'StyledTextAddOns'!
!classDefinition: 'ParagraphStyleEditor class' category: #'StyledTextAddOns'!
ParagraphStyleEditor class
	instanceVariableNames: ''!

!classDefinition: #StyleSetEditor category: #'StyledTextAddOns'!
MenuMorph subclass: #StyleSetEditor
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'StyledTextAddOns'!
!classDefinition: 'StyleSetEditor class' category: #'StyledTextAddOns'!
StyleSetEditor class
	instanceVariableNames: ''!


!CharacterStyleEditor commentStamp: '<historical>' prior: 0!
I am a user interface for creating or editing a CharacterStyle for a StyleSet.

I require a valid StyledTextModel to update when editing is accepted.!

!ParagraphStyleEditor commentStamp: '<historical>' prior: 0!
I am a user interface for managing a ParagraphStyle for a StyleSet.

I am also a character style but add a number of editable values.

paragraphAlignment -- leftFlush, centered, rightFlush
firstLineIndent restLinesIndent rightLineIndent -- pixel indentation of paragraph lines
verticalSpaceBefore verticalSpaceAfter --
bulletPatternString -- patterm used for bullits
  '%.'  --> '1.'  '2.'  '3.'  ...
  'z)'  --> 'a)'  'b)'  'c)' ...
  'Z-' --> 'A-'  'B-'  'C-'  ...
  '° ' --> '° '  '° '  '° '  ...
   ...
!

!StyleSetEditor commentStamp: '<historical>' prior: 0!
I am a user interface for managing a StyleSet for a StyledTextEditor!

!StyleSet methodsFor: '*styledtextaddons' stamp: 'KenD 3/24/2017 14:37:37'!
addCharStyle: aCharacterStyle withShortcut: aChar

	characterStyles := characterStyles , { {aChar. aCharacterStyle.} }.
	
	self triggerEvent: #stylesChanged! !

!CharacterStyle methodsFor: '*styledtextaddons' stamp: 'KenD 3/24/2017 14:07:03'!
privateColor: aColor

	color := aColor

	! !

!CharacterStyle methodsFor: '*styledtextaddons' stamp: 'KenD 3/24/2017 14:12:46'!
privateEmphasis: emphasisCode

	emphasis := emphasisCode 

	! !

!CharacterStyle methodsFor: '*styledtextaddons' stamp: 'KenD 3/24/2017 14:04:13'!
privateFamilyName: aString

	familyName := aString "Font familyName"

	! !

!CharacterStyleEditor methodsFor: 'dropping/grabbing' stamp: 'KenD 3/25/2017 12:51:15'!
aboutToGrab: aMorph
	"submorph is being grabbed by a hand.
	Perform necessary adjustments (if any) and return the actual morph
	that should be added to the hand.
	Answer nil to reject the drag."
"
	Transcript show: 'CharStyleEditor aboutToGrab: ', aMorph printString ; newLine.
"
	| valueToDrag |
	(aMorph isKindOf: VirtualPropertyMenuItem)
		ifTrue: [ valueToDrag := aMorph propertyValue copy ].
	
	valueToDrag isNil
	ifTrue:  [^ self ] "Title selected. User wants to move me. Pick me up"
	ifFalse: [ ^ valueToDrag morphForDrag ]
! !

!CharacterStyleEditor methodsFor: 'events-processing' stamp: 'KenD 4/2/2017 14:58:20'!
accept

	| resultStyle styleIndex styleSet |
	
	styleSet := self styleSet.
	
	(self targetStyle) 
	ifNil: [ "Add a new CharacterStyle"
		resultStyle := self class defaultCharStyle.
		self copyValuesToStyle:resultStyle.
		styleSet addCharStyle: resultStyle withShortcut: self styleShortcut.
		"StyleSet setter above invokes   triggerEvent: #stylesChanged"
	] 
	ifNotNil: [ "Update pre-existing style"
		resultStyle := self targetStyle.
		styleIndex := styleSet characterStyleIndexOf: resultStyle.
		self copyValuesToStyle: resultStyle.
		(self styleShortcut = ((styleSet characterStyles at: styleIndex) at: 1))
		ifFalse: [ (styleSet characterStyles at: styleIndex) at: 1 put: self styleShortcut ].
		styleSet triggerEvent: #stylesChanged
	].
	self delete
! !

!CharacterStyleEditor methodsFor: 'initialization' stamp: 'KenD 3/24/2017 15:08:08'!
addTitle: aString

	titleMorph := WindowTitleMorph title: aString  buttonsNamed: #( close ).
	titleMorph color: Theme current menuTitleBar.
	self addMorphFront: titleMorph.! !

!CharacterStyleEditor methodsFor: 'drawing' stamp: 'KenD 3/24/2017 15:26:39'!
adjustSubmorphsLayout

	| calculatedExtent |
	super adjustSubmorphsLayout.
	calculatedExtent := self morphExtent.
	self morphExtent: (calculatedExtent x max: self minItemWidth) @ calculatedExtent y.
	self titleMorph morphExtent: (calculatedExtent x max: self minItemWidth) @ self titleMorph morphHeight.
	self titleMorph reset.  "Needed after adjustSubmorphsLayout"
! !

!CharacterStyleEditor methodsFor: 'dropping/grabbing' stamp: 'KenD 3/25/2017 12:51:27'!
allowsSubmorphDrag
	"Answer whether our morphs can just be grabbed with the hand, instead of requiring the use of the halo. Redefined to answer true."

	^ true! !

!CharacterStyleEditor methodsFor: 'initialization' stamp: 'KenD 3/25/2017 13:00:08'!
buildMenuItems

	| metaProps propMorph |
	metaProps := self class metaProps.
	
	#(styleName styleShortcut textFont textEmphasis textColor) do: [ :ivarName |
		propMorph := VirtualPropertyMenuItem 
						propName: ivarName 
						morph: self
						propMeta: (metaProps at: ivarName).
		propMorph  target: propMorph;
					  selector: #edit.
		self addMorphBack: propMorph
	].

	self addTitle: 'CharacterStyle'.
	self defaultTarget: self;
		 stayUp: true.
		self addLine.
	
	self add: 'ACCEPT' 
		  target: self 
		  selector: #accept.
	self add: 'CANCEL' 
		  target: self 
		  selector: #cancel.
! !

!CharacterStyleEditor methodsFor: 'events-processing' stamp: 'KenD 3/23/2017 15:59:58'!
cancel

	self delete! !

!CharacterStyleEditor methodsFor: 'events-processing' stamp: 'KenD 3/24/2017 15:33:25'!
closeButtonClicked

	self cancel! !

!CharacterStyleEditor methodsFor: 'styleAccess' stamp: 'KenD 3/24/2017 15:21:39'!
copyValuesFromStyle: aStyle
	"Copy values from a CharacterStyle.  Subclass may add.."
	
	self styleName: aStyle name.
	self textColor:   aStyle color.
	self textFont: (AbstractFont 
								familyName: aStyle familyName 
								pointSize:     aStyle pointSize).
	self textEmphasis: aStyle emphasis.	! !

!CharacterStyleEditor methodsFor: 'styleAccess' stamp: 'KenD 3/24/2017 14:13:35'!
copyValuesToStyle: aStyle
	"Copy values to CharacterStyle.  Subclass may add.."
	
	aStyle privateName: self styleName.
	aStyle privateColor:  self textColor.
	aStyle privateFamilyName: self textFont familyName.
	aStyle privatePointSize:     self textFont pointSize.
	aStyle privateEmphasis:     self textEmphasis.
	! !

!CharacterStyleEditor methodsFor: 'initialization' stamp: 'KenD 3/24/2017 15:21:08'!
defaultCharStyle
	"This could come from CharacterStyle some day.."
	
	| defaultCharStyle defaultFont |
	defaultFont := AbstractFont default.
	defaultCharStyle := CharacterStyle new privateName: 'Name Me'.
	^ defaultCharStyle privateFamilyName: defaultFont familyName
					    pointSize: defaultFont pointSize 
					    emphasis: AbstractFont normalCode
					    color: Color black.
! !

!CharacterStyleEditor methodsFor: 'initialization' stamp: 'KenD 3/24/2017 15:36:35'!
defaultShortcutChar

	| usedShortcuts |
	usedShortcuts := self usedShortcuts.
	^ ('abcdefghijklmnopqrstuvwxyz' 
				detect: [ :char | (usedShortcuts includes: char) not ] ).! !

!CharacterStyleEditor methodsFor: 'events-processing' stamp: 'KenD 3/25/2017 12:52:32'!
edit: propName
"
	Remove
	Rename
	Edit Value
	Reset  to old Value
	Cancel
"
	"@@@FIXME: NYI @@@"
	(HoverHelpMorph contents: 'Need editor for ' , propName asString)
		popUpForHand: self targetMorph world activeHand! !

!CharacterStyleEditor methodsFor: 'initialization' stamp: 'KenD 3/24/2017 15:36:19'!
forSTEModel: aStyledTextModel 
	"Create a new CharacterStyle instance"

	super initialize.
	self styledTextModel: aStyledTextModel.
	self styleShortcut: self defaultShortcutChar.
	"self targetStyle: nil".
	self copyValuesFromStyle: self defaultCharStyle.
	self buildMenuItems; refreshView ! !

!CharacterStyleEditor methodsFor: 'as yet unclassified' stamp: 'KenD 3/25/2017 12:53:35'!
minItemWidth
	"Answer enough space to contain generous title"

	^ Preferences windowTitleFont widthOfString: '0123456789112345678921234567893'
! !

!CharacterStyleEditor methodsFor: 'events-processing' stamp: 'KenD 3/24/2017 15:25:49'!
refreshView

	"Something may have changed.."
	self removeAllMorphs.
	self buildMenuItems.
	self adjustSubmorphsLayout;
		yourself! !

!CharacterStyleEditor methodsFor: 'accessing' stamp: 'KenD 3/24/2017 13:45:24'!
styleName

	^ styleName! !

!CharacterStyleEditor methodsFor: 'accessing' stamp: 'KenD 3/24/2017 13:44:40'!
styleName: aString

	styleName := aString! !

!CharacterStyleEditor methodsFor: 'accessing' stamp: 'KenD 3/24/2017 13:33:16'!
styleSet
	"My defaultTarget is my containing StyleSet"

	^ self styledTextModel styleSet! !

!CharacterStyleEditor methodsFor: 'accessing' stamp: 'KenD 3/24/2017 13:53:38'!
styleShortcut
		
		^ styleShortcut ! !

!CharacterStyleEditor methodsFor: 'accessing' stamp: 'KenD 3/24/2017 13:53:00'!
styleShortcut: aChar

	(self usedShortcuts includes: aChar) 
		ifTrue:   [ self inform: '$', aChar asString, ' is already used as a shortcut' ]
		ifFalse:  [ styleShortcut := aChar ]! !

!CharacterStyleEditor methodsFor: 'accessing' stamp: 'KenD 3/24/2017 13:33:52'!
styledTextModel

	^ styledTextModel! !

!CharacterStyleEditor methodsFor: 'accessing' stamp: 'KenD 3/24/2017 13:34:15'!
styledTextModel: aStyledTextModel

	styledTextModel := aStyledTextModel ! !

!CharacterStyleEditor methodsFor: 'initialization' stamp: 'KenD 3/29/2017 15:06:56'!
styledTextModel: aStyledTextModel  shortcutChar: aChar charStyle: aCharStyle

	super initialize.
	self styledTextModel: aStyledTextModel.
	styleShortcut := aChar.
	self targetStyle: aCharStyle.
	self copyValuesFromStyle: aCharStyle.
	self buildMenuItems; refreshView ! !

!CharacterStyleEditor methodsFor: 'accessing' stamp: 'KenD 3/24/2017 13:43:40'!
targetStyle

	^ targetStyle! !

!CharacterStyleEditor methodsFor: 'accessing' stamp: 'KenD 3/24/2017 13:44:00'!
targetStyle: aStyle

	targetStyle := aStyle ! !

!CharacterStyleEditor methodsFor: 'accessing' stamp: 'KenD 3/24/2017 13:55:10'!
textColor
		
		^ textColor! !

!CharacterStyleEditor methodsFor: 'accessing' stamp: 'KenD 3/24/2017 13:55:23'!
textColor: aColor
		
		textColor := aColor! !

!CharacterStyleEditor methodsFor: 'accessing' stamp: 'KenD 3/24/2017 13:54:56'!
textEmphasis
		
		^ textEmphasis! !

!CharacterStyleEditor methodsFor: 'accessing' stamp: 'KenD 3/24/2017 13:54:39'!
textEmphasis: emphasisCode
		
		textEmphasis := emphasisCode ! !

!CharacterStyleEditor methodsFor: 'accessing' stamp: 'KenD 3/24/2017 13:53:51'!
textFont
		
		^ textFont ! !

!CharacterStyleEditor methodsFor: 'accessing' stamp: 'KenD 3/24/2017 13:54:06'!
textFont: aFont
		
		textFont := aFont ! !

!CharacterStyleEditor methodsFor: 'accessing' stamp: 'KenD 3/24/2017 15:31:18'!
titleMorph

	^ titleMorph! !

!CharacterStyleEditor methodsFor: 'accessing' stamp: 'KenD 3/24/2017 13:51:09'!
usedShortcuts

	| shortcuts |
	shortcuts := Set new.
	" Pick off shortcut characters"
	self styleSet characterStyles  do: [ :pair | shortcuts add: (pair at: 1) ]. 
	self styleSet paragraphStyles do: [ :pair | shortcuts add: (pair at: 1) ]. 
	^ shortcuts! !

!CharacterStyleEditor class methodsFor: 'private' stamp: 'KenD 3/23/2017 19:03:49'!
defaultCharStyle
"
 	self defaultCharStyle inspect.
"

	| defaultCharStyle defaultFont |
	defaultFont := AbstractFont default.
	defaultCharStyle := CharacterStyle new privateName: 'unnamed'.
	^ defaultCharStyle privateFamilyName: defaultFont familyName
					    pointSize: defaultFont pointSize 
					    emphasis: AbstractFont normalCode
					    color: Color black.
! !

!CharacterStyleEditor class methodsFor: 'class initialization' stamp: 'KenD 3/24/2017 13:38:53'!
initialize
"
	CharacterStyleEditor initialize.
"
	CharSetMetaProps := Dictionary new.
	"CharSet display properties"
	CharSetMetaProps at: #styleName       put: (MetaProperty metaPropNamed: #acceptsString).
	CharSetMetaProps at: #styleShortcut put: (MetaProperty metaPropNamed: #acceptsCharacter).
	CharSetMetaProps at: #textColor        put: (MetaProperty metaPropNamed: #acceptsColor).
	CharSetMetaProps at: #textFont         put: (MetaProperty metaPropNamed: #acceptsFont).
	CharSetMetaProps at: #textEmphasis put: (MetaProperty metaPropNamed: #acceptsEmphasis).
! !

!CharacterStyleEditor class methodsFor: 'metaProperties' stamp: 'KenD 3/24/2017 15:06:33'!
metaProps

	^ CharSetMetaProps! !

!CharacterStyleEditor class methodsFor: 'instance creation' stamp: 'KenD 3/24/2017 13:26:35'!
newForSTEModel: aStyledTextModel

	^ self new forSTEModel: aStyledTextModel ! !

!CharacterStyleEditor class methodsFor: 'instance creation' stamp: 'KenD 3/24/2017 13:36:53'!
styledTextModel: aStyledTextModel shortcutChar: aChar charStyle: aCharStyle

	^ self new styledTextModel: aStyledTextModel  shortcutChar: aChar charStyle: aCharStyle! !

!CharacterStyleEditor class methodsFor: 'private' stamp: 'KenD 3/23/2017 19:07:32'!
unusedShortcutChar: aStyleSet

	| usedShortcuts |
	usedShortcuts := Set new.
	" Pick off shortcut characters"
	aStyleSet characterStyles  do: [ :pair | usedShortcuts add: (pair at: 1) ]. 
	aStyleSet paragraphStyles do: [ :pair | usedShortcuts add: (pair at: 1) ]. 
	^ ('abcdefghijklmnopqrstuvwxyz' 
				detect: [ :char | (usedShortcuts includes: char) not ] ).! !
CharacterStyleEditor initialize!
