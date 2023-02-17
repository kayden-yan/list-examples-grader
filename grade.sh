CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'

## clone the student submission to /student-submission
rm -rf student-submission
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
rm -rf test-field
mkdir test-field
mkdir test-field/lib
cp lib/hamcrest-core-1.3.jar test-field/lib
cp lib/junit-4.13.2.jar test-field/lib
cp $FILE test-field
cp TestListExamples.java test-field

## Complie
set +e
cd test-field
javac -cp $CPATH *.java > compile-result.txt
found=$(wc -l compile-result.txt)
if [[ $found > 0 ]]; then
    echo "Compile Error!"
    echo compile-result.txt
    exit
else
    echo "Compile Success!"
fi

## Run Test
java -cp $CPATH org.junit.runner.JUnitCore TestListExamples > junit-result.txt
grep -o "Tests run: [0-9,]*," junit-result.txt
