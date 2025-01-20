// Tests in this file are NOT run in the PR pipeline. They are run in the continuous testing pipeline along with the ones in pr_test.go
package test

import (
	"fmt"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"github.com/terraform-ibm-modules/ibmcloud-terratest-wrapper/testhelper"
)

func TestRunRestoredDBExample(t *testing.T) {
	t.Parallel()

	options := testhelper.TestOptionsDefaultWithVars(&testhelper.TestOptions{
		Testing:            t,
		TerraformDir:       "examples/backup",
		Prefix:             "edb-backup",
		BestRegionYAMLPath: regionSelectionPath,
		ResourceGroup:      resourceGroup,
		TerraformVars: map[string]interface{}{
			"edb_version": "12",
		},
		CloudInfoService: sharedInfoSvc,
	})

	output, err := options.RunTestConsistency()
	assert.Nil(t, err, "This should not have errored")
	assert.NotNil(t, output, "Expected some output")
}

func TestRunPointInTimeRecoveryDBExample(t *testing.T) {
	t.Parallel()

	options := testhelper.TestOptionsDefaultWithVars(&testhelper.TestOptions{
		Testing:       t,
		TerraformDir:  "examples/pitr",
		Prefix:        "edb-pitr",
		ResourceGroup: resourceGroup,
		Region:        fmt.Sprint(permanentResources["enterpriseDbPITRRegion"]),
		TerraformVars: map[string]interface{}{
			"pitr_id":     permanentResources["enterpriseDbPITRCrn"],
			"edb_version": permanentResources["enterpriseDbPITRVersion"],
			"members":     "3", // Lock members to 3 as the permanent enterprise db instances has 3 members
		},
		CloudInfoService: sharedInfoSvc,
	})

	output, err := options.RunTestConsistency()
	assert.Nil(t, err, "This should not have errored")
	assert.NotNil(t, output, "Expected some output")
}

func TestRunBasicExample(t *testing.T) {
	t.Parallel()

	options := testhelper.TestOptionsDefaultWithVars(&testhelper.TestOptions{
		Testing:            t,
		TerraformDir:       "examples/basic",
		Prefix:             "edb",
		BestRegionYAMLPath: regionSelectionPath,
		ResourceGroup:      resourceGroup,
		TerraformVars: map[string]interface{}{
			"edb_version": "12",
		},
		CloudInfoService: sharedInfoSvc,
	})

	output, err := options.RunTestConsistency()
	assert.Nil(t, err, "This should not have errored")
	assert.NotNil(t, output, "Expected some output")
}

func testPlanICDVersions(t *testing.T, version string) {
	t.Parallel()

	options := testhelper.TestOptionsDefaultWithVars(&testhelper.TestOptions{
		Testing:      t,
		TerraformDir: "examples/basic",
		TerraformVars: map[string]interface{}{
			"edb_version": version,
		},
		CloudInfoService: sharedInfoSvc,
	})
	output, err := options.RunTestPlan()
	assert.Nil(t, err, "This should not have errored")
	assert.NotNil(t, output, "Expected some output")
}

func TestPlanICDVersions(t *testing.T) {
	t.Parallel()

	// This test will run a terraform plan on available stable versions of enterprisedb
	versions, _ := sharedInfoSvc.GetAvailableIcdVersions("enterprisedb")
	for _, version := range versions {
		t.Run(version, func(t *testing.T) { testPlanICDVersions(t, version) })
	}
}

func TestRunFSCloudExample(t *testing.T) {
	t.Parallel()

	options := testhelper.TestOptionsDefaultWithVars(&testhelper.TestOptions{
		Testing:      t,
		TerraformDir: "examples/fscloud",
		Prefix:       "edb-fscloud",
		Region:       "us-south", // For FSCloud locking into us-south since that is where the HPCS permanent instance is
		/*
		 Comment out the 'ResourceGroup' input to force this tests to create a unique resource group to ensure tests do
		 not clash. This is due to the fact that an auth policy may already exist in this resource group since we are
		 re-using a permanent HPCS instance. By using a new resource group, the auth policy will not already exist
		 since this module scopes auth policies by resource group.
		*/
		//ResourceGroup: resourceGroup,
		TerraformVars: map[string]interface{}{
			"access_tags": permanentResources["accessTags"],
			"edb_version": "12", // Always lock this test into the latest supported Enterprise DB version
		},
		CloudInfoService: sharedInfoSvc,
	})

	options.SkipTestTearDown = true
	output, err := options.RunTestConsistency()
	assert.Nil(t, err, "This should not have errored")
	assert.NotNil(t, output, "Expected some output")

	// check for outputs
	outputs := terraform.OutputAll(options.Testing, options.TerraformOptions)
	expectedOutputs := []string{"port", "hostname"}
	_, outputErr := testhelper.ValidateTerraformOutputs(outputs, expectedOutputs...)
	assert.NoErrorf(t, outputErr, "Some outputs not found or nil")
	options.TestTearDown()
}
