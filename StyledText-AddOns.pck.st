'From Cuis 5.0 of 7 November 2016 [latest update: #3068] on 21 March 2017 at 11:37:56 am'!
'Description I add user interface elements for StyleSet, ParagraphStyles and CharacterStyles for a StyledTextEditor.'!
!provides: 'StyledText-AddOns' 1 0!
!requires: 'Morph-MetaProperties' 1 59 nil!
!requires: 'StyledTextInstaller' 1 6 nil!
!classDefinition: #CharacterStyleEditor category: #'StyledText-AddOns'!
MenuMorph subclass: #CharacterStyleEditor
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'StyledText-AddOns'!
!classDefinition: 'CharacterStyleEditor class' category: #'StyledText-AddOns'!
CharacterStyleEditor class
	instanceVariableNames: ''!

!classDefinition: #ParagraphStyleEditor category: #'StyledText-AddOns'!
MenuMorph subclass: #ParagraphStyleEditor
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'StyledText-AddOns'!
!classDefinition: 'ParagraphStyleEditor class' category: #'StyledText-AddOns'!
ParagraphStyleEditor class
	instanceVariableNames: ''!

!classDefinition: #StyleSetEditor category: #'StyledText-AddOns'!
MenuMorph subclass: #StyleSetEditor
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'StyledText-AddOns'!
!classDefinition: 'StyleSetEditor class' category: #'StyledText-AddOns'!
StyleSetEditor class
	instanceVariableNames: ''!


!CharacterStyleEditor commentStamp: '<historical>' prior: 0!
I am a user interface for managing a CharacterStyle for a StyleSet!

!ParagraphStyleEditor commentStamp: '<historical>' prior: 0!
I am a user interface for managing a ParagraphStyle for a StyleSet!

!StyleSetEditor commentStamp: '<historical>' prior: 0!
I am a user interface for managing a StyleSet for a StyledTextEditor!
