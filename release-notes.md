# Nictiz-R4-MedicationProcess Release Notes

This document contains release notes per profile, indicating differences with their STU3 versions, deviations from the [profiling guidelines](https://informatiestandaarden.nictiz.nl/wiki/FHIR:V1.0_FHIR_Profiling_Guidelines_R4) and other points of interest.

## MedicationOverview.xml
- Updated references.
- Updated mappings, moved mappings to extension where possible.
- Replaced fixed values in `List.code` with a pattern to align with the R4 profiling guidelines..
- Added `List.entry` slices for BodyHeight and BodyWeight.

## Bundle-MedicationOverview.xml
- Moved mappings to MedicationOverview profile.
- Added mandatory slice for Patient to be more explicit that the patient needs to be included.

## ext-MedicationOverview.SourceOrganization.xml
- Moved mappings from MedicationOverview.xml to this extension.
- Renamed extension to ext-MedicationOverview.SourceOrganization to align with the R4 profiling guidelines.

## ext-MedicationOverview.Verification.xml
- Moved mappings from MedicationOverview.xml to this extension.
- Renamed extension to ext-MedicationOverview.SourceOrganization to align with the R4 profiling guidelines.
- Moved specification to `value[x]` instead on extension level to align with the R4 profiling guidelines.

## SearchParameters
- Moved to the nl-core folder in the zib2020 R4 repository.

## CapabilityStatements
- Changed name, url and file name from medication-clientcapabilities to MedicationProcess-ClientCapabilities to be more explicit.
- Updated references to profiles and searchparameters to most recent versions.

## OperationDefinition Medication-Overview.xml
- Improved wording in description and documentation to be more generic and readable.
- Moved Medication-Overview Bundle profile to an HL7 core extension due to changes made to the base resource in R4.
- Renamed out parameter from Bundle to return to align more with HL7 OperationDefinitions.

## Examples
- TODO need to generate R4 examples.