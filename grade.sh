CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'

## Clears out the folders
rm -rf student-submission
rm -rf test-field

## clone the student submission to /student-submission
git clone $1 student-submission
echo 'Finished cloning'

## check the correct file submitted
FILE=student-submission/ListExamples.java
if test -f "$FILE"; then
    echo "$FILE exists."
else
    echo "Missing $FILE."
    exit
fi

## Copy the necessary files into one folder
mkdir test-field
mkdir test-field/lib
cp lib/hamcrest-core-1.3.jar test-field/lib
cp lib/junit-4.13.2.jar test-field/lib
cp $FILE test-field
cp TestListExamples.java test-field

## Complie
set +e
cd test-field
javac -cp $CPATH *.java > compile_result.txt
found=$(wc -l compile_result.txt)
if [[ $found > 0 ]]; then
    echo "Compile Error!"
    echo compile_result.txt
    exit
else
    echo "Compile Success!"
fi

## Run Test
java -cp $CPATH org.junit.runner.JUnitCore TestListExamples > junit_result.txt
if grep -q "OK" junit_result.txt; then
  echo "All tests passed!"
  echo "Score: 100 %"
else
    grep -o "Tests run: [0-9,]*," junit_result.txt > test_run.txt
    num_test=$(sed -e 's/.*run: \(.*\),.*/\1/' test_run.txt)
    failure_str=$(grep -o "Failures: [0-9,]*" junit_result.txt)
    num_fail=$(echo $failure_str | tr -dc '0-9')
    echo "Test_run: " $num_test
    echo "Failures: " $num_fail
    echo "Score: " $((($num_test - $num_fail) / $num_test * 100)) "%"
fi

## Clears out the folders
rm -rf student-submission
rm -rf test-field