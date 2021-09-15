# Nictiz-R4-MedicationProcess Release Notes

This document contains release notes per profile, indicating differences with their STU3 versions, deviations from the [profiling guidelines](https://informatiestandaarden.nictiz.nl/wiki/FHIR:V1.0_FHIR_Profiling_Guidelines_R4) and other points of interest.

## MedicationOverview.xml
- Updated references.
- Updated mappings, moved mappings to extension where possible.

## Bundle-MedicationOverview.xml
- Updated mappings.
- Added mandatory slice for Patient so it is more explicitly stated that it is required.

## ext-MedicationOverview.SourceOrganization.xml
- Moved mappings from MedicationOverview.xml to this extension.
- Renamed extension to ext-MedicationOverview.SourceOrganization to align with the R4 profiling guidelines

## ext-MedicationOverview.Verification.xml
- Moved mappings from MedicationOverview.xml to this extension.
- Renamed extension to ext-MedicationOverview.SourceOrganization to align with the R4 profiling guidelines

## SearchParameters
Moved to the nl-core folder in the zib2020 R4 repo

## CapabilityStatements
- Changed name, url and file name from medication-clientcapabilities to MedicationProcess-ClientCapabilities to be more explicit.
- Updated references to profiles and searchparameters to most recent versions

## OperationDefinition Medication-Overview.xml
- Improved wording in description and documentation to be more generic and readable.
- Moved Medication-Overview Bundle profile to an HL7 core extension due to changes made to the base resource in R4.
- Replaced in parameter type Identifier to Id.
- Renamed out parameter from Bundle to return to align more with HL7 OperationDefinitions.